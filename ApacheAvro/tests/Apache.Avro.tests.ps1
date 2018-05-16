Import-Module (Split-Path $PSScriptRoot) -Force

Describe Apache.Avro {
    Context ConvertFrom-ApacheAvro {
        $mockFile = Get-Item mockData
        It "Should convert avro to custom objects" {
            $mockFile.FullName | ConvertFrom-ApacheAvro | Should BeOfType System.Management.Automation.PSCustomObject
        }
    }
}