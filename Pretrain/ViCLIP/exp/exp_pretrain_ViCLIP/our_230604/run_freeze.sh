export MASTER_PORT=$((12000 + $RANDOM % 20000))
export OMP_NUM_THREADS=1
echo "PYTHONPATH: ${PYTHONPATH}"
which_python=$(which python)
echo "which python: ${which_python}"
export PYTHONPATH=${PYTHONPATH}:${which_python}
export PYTHONPATH=${PYTHONPATH}:.
echo "PYTHONPATH: ${PYTHONPATH}"

JOB_NAME='our_230604_resized_freeze'
# JOB_NAME='debug'
OUTPUT_DIR="$(dirname $0)/$JOB_NAME"
LOG_DIR="$(dirname $0)/logs/${JOB_NAME}"
PARTITION='Gvlab-P1'
NNODE=8
NUM_GPUS=8
NUM_CPU=128

srun -p ${PARTITION} \
    --job-name=${JOB_NAME} \
    -n${NNODE} \
    --gres=gpu:${NUM_GPUS} \
    --ntasks-per-node=1 \
    --cpus-per-task=${NUM_CPU} \
    torchrun.sh \
    --nnodes=${NNODE} \
    --nproc_per_node=${NUM_GPUS} \
    --rdzv_backend=c10d \
    tasks/pretrain.py \
    $(dirname $0)/config.py \
    wandb.enable False \
    output_dir ${OUTPUT_DIR}
