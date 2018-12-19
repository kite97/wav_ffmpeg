ver = 2.0.5

all:
	@erl -make
clean:
	@rm -f *.beam *~  server.pid server.log
cleanall: clean
	rm -rf tasks processing succ fail processinglog
version: 
	@echo $(ver)
prepare:
	mkdir -p tasks processing succ fail processinglog
split:
	@./tools/split_task.sh $(allfilenames)
run_server: all
	./server server@10.1.70.181 $(task).index
run_client: all
	./client client@10.1.70.181 1 server@10.1.70.181
renamewb:
	./tools/rename_wb.sh <$(allfilenames) >$(allfilenames)_renamewb.log 2>&1
renamenb:
	@./tools/rename_nb.sh <$(allfilenames) >$(allfilenames)_renamenb.log 2>&1
check:
	@./tools/check.sh <$(allfilenames) >$(allfilenames)_check.log 2>&1
rmold:
	@./tools/rmold.sh <$(allfilenames) >$(allfilenames)_rmold.log 2>&1
test_:
	mkdir -p pre todo
	rm -f tasks/* processing/* succ/* fail/* processinglog/*
	cp pre/* tasks
	rm -f todo/*
	cp audio.amr todo/
archive:
	git archive --prefix=wavconv-$(ver)/ -o wavconv-$(ver).tar.gz master
