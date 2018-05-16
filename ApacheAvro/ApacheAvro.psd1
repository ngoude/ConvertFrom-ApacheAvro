@{
    RootModule = 'ApacheAvro.psm1'
    ModuleVersion = '1.0.0.1'
    GUID = '6205714a-0439-440c-b0d1-fa25b1001e57'
    Author = 'Niklas Goude'
    CompanyName = 'Goude'
    Copyright = '(c) 2018 Goude. All rights reserved.'
    Description = 'Convert Apache Avro to JSON.'
    PowerShellVersion = '5.0'
    RequiredAssemblies = @(
        'net45\Microsoft.Hadoop.Avro.dll',
        'net45\Newtonsoft.Json.dll'
    )
    FunctionsToExport = @(
        'ConvertFrom-ApacheAvro'
    )
    #ModuleList = @('ApacheAvro.psm1')
    FileList = @(
        'ApacheAvro.psd1',
        'ApacheAvro.psm1'
    )
    
    HelpInfoURI = 'https://github.com/ngoude/ConvertFrom-ApacheAvro'
}

