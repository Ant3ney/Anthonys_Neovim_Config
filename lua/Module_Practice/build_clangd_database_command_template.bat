setlocal

set ubt_path=____@@@@ubt_path@@@@____
set project_path=____@@@@project_path@@@@____
set project_name=____@@@@project_name@@@@____
set output_dir=____@@@@output_dir@@@@____

"%ubt_path%" -mode=generateclangdatabase -project="%project_path%" -game -engine "%project_name%Editor" development win64 -outputdir="%output_dir%"

endlocal
