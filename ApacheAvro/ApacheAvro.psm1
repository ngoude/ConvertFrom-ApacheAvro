function ConvertFrom-ApacheAvro
{
    <#
        .SYNOPSIS
        Converts Apache Avro to custom objects.
    
        .DESCRIPTION
        The ConvertFrom-ApacheAvro function converts Apache Avro to custom objects.

        .PARAMETER FilePath
        Specifies the full path to a Apache Avro file.

        .EXAMPLE
        ConvertFrom-ApacheAvro -FilePath C:\Blob\file

        Converts the content of C:\BlobStorage\file from Apache Avro to custom objects.

        .EXAMPLE
        $files = Get-ChildItem 'C:\BlobStorage' -Recurse -File
        $files.FullName | ConvertFrom-ApacheAvro

        Converts the content of all files in C:\BlobStorage from Apache Avro to custom objects.
    #>
    param (
        [parameter(Mandatory = $true,
            ValueFromPipeLine = $true,
            ValueFromPipeLineByPropertyName = $true)]
        [string[]]$FilePath
    )
    begin {
        $items = @()
    }
    process {
        foreach ($path in $FilePath) {
            [System.IO.FileStream]$stream = [System.IO.FIle]::Open($Path, [System.IO.FileMode]::Open)
            
            $reader = [Microsoft.Hadoop.Avro.Container.AvroContainer]::CreateGenericReader($stream)
            while ($reader.MoveNext()) {
                foreach ($record in $reader.Current.Objects) {
                    $bodyText = [System.Text.Encoding]::UTF8.GetString($record.Body)
                    $items += "$bodyText"
                }
            }
            $stream.Dispose()
            $reader.Dispose()
        }
    }
    end {
        $items | ConvertFrom-Json
    }
}