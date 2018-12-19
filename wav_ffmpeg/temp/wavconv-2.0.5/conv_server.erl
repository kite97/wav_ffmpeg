-module(conv_server).

-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


-record(state, { total = 0
               , succ =  0
               , fail = 0
               , processing = 0
               , remain = 0
               , task
               , log}).

-define(SERVER, ?MODULE).
-define(timeout, 10000).


%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------

%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([NamePackages]) ->
    io:format("NamePackages: ~p~n", [NamePackages]),
    T = get_file_names(NamePackages),
    io:format("T: ~p~n", [T]),
    L = length(T),
    {ok, Log} = file:open("server.log", [write, append]),
    {ok, #state{ total = L
               , remain = L
               , task = T
               , log = Log}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(status, _From, #state{ total = Total
                                 , succ = Succ
                                 , fail = Fail
                                 , processing = Processing
                                 , remain = Remain} = State) ->
    {reply, {Total, Succ, Fail, Processing, Remain}, State};
handle_call(req, _From, #state{task= []} = State) ->
    {reply, {none, []}, State};
handle_call(req, _From, #state{ task= [H|Task]
                              , processing = Processing
                              , log = Log} = State) ->
    case get_file_names("tasks/"++H) of
        no_exist ->
            io:format(Log, "~p not exist~n", [H]),
            {reply, {H,[]}, State#state{ task = Task
                                          , processing = Processing+1}};
        Names ->
            Cmd = "mv "++"tasks/"++H ++" processing/"++H,
            io:format(Log, "~s~n", [Cmd]),
            _CmdR = os:cmd(Cmd),
            {reply, {H,Names}, State#state{ task = Task
                                  , processing = Processing + 1}}
    end;
handle_call({rep, File, Result}, _From, #state{ succ = Succ
                                               , fail = Fail
                                               , processing = Processing
                                               , remain = Remain
                                               , log = Log} = State) ->
    io:format("file ~p: ~p~n", [File, Result]),
    Pass = case File of
               _ when Result =:= none ->
                   false;
               _ ->
                   lists:all(fun({_File, RList}) ->
                                     lists:all(fun({_,_,R}) -> case R of
                                                                   succ -> true;
                                                                   _ -> false
                                                               end end, RList)
                             end, Result)
           end,
    case Result of
        none ->
            ok;
        _ ->
            {ok, ProcessLog} = file:open("processinglog/"++File++".log", [write, append]),
            lists:foreach(fun({SubFile, SubFileResult}) ->
                                  lists:foreach(fun(SubFileResultDetail) ->
                                                       io:format(ProcessLog, "~p ~p~n", [SubFile, SubFileResultDetail]) end, SubFileResult)
                          end, Result),
            file:close(ProcessLog)
    end,
    {NSucc, NFail} = case Pass of
                         true ->
                             Cmd = "mv "++"processing/"++File ++" succ/"++File,
                             io:format(Log, "~s~n", [Cmd]),
                             _CmdR = os:cmd(Cmd),
                             {Succ+1, Fail};
                         _ ->
                             Cmd = "mv "++"processing/"++File ++" fail/"++File,
                             io:format(Log, "~s~n", [Cmd]),
                             _CmdR = os:cmd(Cmd),
                             {Succ, Fail+1}
                     end,
    {reply, ok, State#state{ remain = Remain-1
                           , processing = Processing-1
                          , succ = NSucc
                          , fail = NFail}};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

get_file_names(Src) ->
    case file:read_file(Src) of
        {ok, Bin} ->
            lists:map(fun(B) -> binary_to_list(B) end,
                lists:filter(fun(<<>>) -> false;
                                (_) -> true end, binary:split(Bin, <<"\n">>, [global])));
        _ ->
            no_exist
    end.
