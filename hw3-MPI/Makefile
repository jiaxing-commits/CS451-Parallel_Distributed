# .PHONY: all mpi-auto mpi-scp mpi-compile

# all: mpi-auto 

# mpi-auto: mpi-scp
# 	@cd ~ && mpirun -np 4 -hostfile hosts ./mpi-gauss 1400 4

# mpi-scp: mpi-compile mpi-gauss
# 	@scp mpi-gauss mpi-instance-1:.
# 	@scp mpi-gauss mpi-instance-2:.
# 	@scp mpi-gauss mpi-instance-3:.
# 	@mv mpi-gauss ~

# mpi-compile: mpi-gauss.c
# 	@mpicc mpi-gauss.c -o mpi-gauss -lm
# 	@chmod 777 mpi-gauss



#------------------------------------------------------
# .PHONY: all mpi-auto mpi-scp mpi-compile

# all: mpi-auto 

# mpi-auto: mpi-scp
# 	@cd ~ && mpirun -np 4 -hostfile hosts ./mtest 

# mpi-scp: mpi-compile mtest
# 	@scp mtest mpi-instance-1:.
# 	@scp mtest mpi-instance-2:.
# 	@scp mtest mpi-instance-3:.
# 	@mv mtest ~

# mpi-compile: mtest.c
# 	@mpicc mtest.c -o mtest 
# 	@chmod 777 mtest

# ------------------------------------------------------------------

.PHONY: all mpi-auto mpi-scp mpi-compile

all: mpi-auto 

mpi-auto: mpi-scp
	@cd ~ && mpirun -np 4 -hostfile hosts ./no_scatter 10 2

mpi-scp: mpi-compile no_scatter
	@scp no_scatter mpi-instance-1:.
	@scp no_scatter mpi-instance-2:.
	@scp no_scatter mpi-instance-3:.
	@mv no_scatter ~

mpi-compile: no_scatter.c
	@mpicc no_scatter.c -o no_scatter -lm
	@chmod 777 no_scatter