@echo off

for /f "tokens=6" %%f in ('powercfg /L ^| findstr \(Equilibrado') do (
echo Cambiando a plan Equilibrado
powercfg /setactive %%f
)

powercfg /L

for /f "tokens=6" %%g in ('powercfg /L ^| findstr IesGraoEquilibrado') do (
echo eliminado plan de energia IesGraoEquilibrado
powercfg /D %%g
)

echo importando plan de energia IesGraoEquilibrado.pow
powercfg /IMPORT C:\scripts\IesGraoEquilibrado.pow

for /f "tokens=6" %%d in ('powercfg /L ^| findstr IesGraoEquilibrado') do (
echo .
echo activando plan de energia IesGraoEquilibrado
powercfg /setactive %%d
)

powercfg /L
