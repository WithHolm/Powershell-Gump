New-PezView -Name 'app' -Root -Size 99% -Direction down -Definition {
    New-PezView -name 'top' -Size 50% -Definition {
        New-PezView -name 'left' -Size 40% -Direction across -Definition{
            New-PezView -name 'leftTop' -Size 50% -Direction down
            New-PezView -name 'leftBottom' -Size 50%
        }
        New-PezView -name 'right' -Size 60%
    }
    New-PezView -name 'bottom' -Size 80%
} -Verbose
New-PezView -Name 'pause' -Size 1% -Parent 'root'