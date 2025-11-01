;------------------------------------------------------------
; ExtractYearFromDate.pro  (ENVI 6.2)
; Minimal routine used by a custom ENVITask.
; Converts acquisition_time-ish text to an integer year.
;
; INPUTS
;   INPUT_DATETIME  - string or scalar, e.g. '2021-07-11T00:00:00'
; OUTPUTS
;   OUTPUT_YEAR     - LONG, e.g. 2021
;------------------------------------------------------------
PRO ExtractYearFromDate, INPUT_DATETIME, OUTPUT_YEAR
  COMPILE_OPT IDL2
  dt_str   = STRING(INPUT_DATETIME)
  year_str = STRMID(dt_str, 0, 4)
  IF ~STRMATCH(year_str, '20??') THEN year_str = '0'
  OUTPUT_YEAR = FIX(year_str)
END
