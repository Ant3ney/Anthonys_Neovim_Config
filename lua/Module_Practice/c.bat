setlocal

set project_path=____@@@@project_path@@@@____
set project_name=____@@@@project_name@@@@____
set ubt_path=____@@@@ubt_path@@@@____
set output_dir=____@@@@output_dir@@@@____

"%ubt_path%" -mode=generateclangdatabase -project="%project_name%" -game -engine "%project_name%Editor" development -outputdir="%output_dir%" win64

endlocal
