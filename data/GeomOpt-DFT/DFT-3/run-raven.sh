#!/bin/bash -l

#SBATCH -o ./tjob.out.%j
#SBATCH -e ./tjob.err.%j
#SBATCH -D ./
#SBATCH -J test_slurm
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=72
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kokott@fhi-berlin.mpg.de
#SBATCH --time=02:00:00

module load gcc/11 cuda/11.4

srun /u/seko/software/FHIaims/build/a3f7d1a56_cmake.O3_gpu_external_elpa4/aims.230524.scalapack.mpi.x > aims.out 2> aims.err
