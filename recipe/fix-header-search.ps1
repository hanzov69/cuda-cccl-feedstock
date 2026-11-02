# CCCL CMake configs (thrust/cub/libcudacxx) search for headers at
# <cmake-dir>/../../../include{,/cccl} (Linux layout), but bld.bat puts them at
# Library\include\targets\<arch>, which we add to find_path search list here
param([string]$arch)
$ErrorActionPreference = "Stop"
$cmake = Join-Path $env:PREFIX ("Library/lib/{0}/cmake" -f $arch)
$anchor = '    "${CMAKE_CURRENT_LIST_DIR}/${from_install_prefix}/include"'
$extra = @(
    ('    "${CMAKE_CURRENT_LIST_DIR}/../../../../include/targets/' + $arch + '"'),
    ('    "${CMAKE_CURRENT_LIST_DIR}/../../../../include/targets/' + $arch + '/cccl"')
)
foreach ($pkg in @("thrust", "cub", "libcudacxx")) {
    $f = Join-Path $cmake ($pkg + "/" + $pkg + "-header-search.cmake")
    $c = Get-Content $f -Raw
    if ($c -match "include/targets/") {
        Write-Host "skip $f (already patched)"
        continue
    }
    $eol = if ($c -match "`r`n") { "`r`n" } else { "`n" }
    $new = $c -replace [regex]::Escape($anchor), (($extra -join $eol) + $eol + $anchor)
    if ($new -ceq $c) {
        throw "anchor not found in $f"
    }
    Set-Content -Path $f -Value $new -NoNewline
    Write-Host "patched $f"
}
