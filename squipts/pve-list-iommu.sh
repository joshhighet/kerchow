# qemu-system-x86_64 -machine help
# /usr/sbin/pve-efiboot-tool refresh
for d in /sys/kernel/iommu_groups/*/devices/*
    do n=${d#*/iommu_groups/*}; n=${n%%/*}
    printf 'IOMMU group %s ' "$n"; lspci -nns "${d##*/}"
    done