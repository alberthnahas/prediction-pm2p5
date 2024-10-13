### CLEAR WORKSPACE ###
rm(list = ls())
gc()

today <- format(Sys.Date(), "%Y-%m-%d")
yesterday <- format(Sys.Date()-1, "%Y-%m-%d")

date_in <- print(paste0("        'date': '",yesterday,"',"))

fout <- file("02_download.pm2p5.py")
writeLines(c("#!/usr/bin/env python",
             "",
             "import cdsapi",
             "",
             "c = cdsapi.Client()",
             "",
             "c.retrieve(",
             "    'cams-global-atmospheric-composition-forecasts',",
             "    {",
             "        'variable': [",
             "        'particulate_matter_2.5um',",
             "        ],", 
                    date_in,     
             "        'time': '12:00',",
             "        'leadtime_hour': [",
             "            '29', '30', '31',",
             "            '32', '33', '34',",
             "            '35', '36', '37',",
             "            '38', '39', '40',",
             "            '41', '42', '43',",                                       
             "            '44', '45', '46',",
             "            '47', '48', '49',",
             "            '50', '51', '52',",
             "            '53', '54', '55',",
             "            '56', '57', '58',",
             "            '59', '60', '61',",
             "            '62', '63', '64',",
             "            '65', '66', '67',",
             "            '68', '69', '70',",
             "            '71', '72', '73',",
             "            '74', '75', '76',",
             "            '77', '78', '79',",
             "            '80', '81', '82',",
             "            '83', '84', '85',",
             "            '86', '87', '88',",
             "            '89', '90', '91',",
             "            '92', '93', '94',",
             "            '95', '96', '97',",
             "            '98', '99', '100',",
             "        ],",
             "        'type': 'forecast',",
             "        'area': [",
             "            15, 90, -15,",
             "            150,",
             "        ],",
             "        'format': 'netcdf_zip',",
             "        'pressure_level': '1000',",
             "    },",
             "    'download.netcdf_zip')"
             ), 
           fout)
