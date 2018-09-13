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
          dir C:\BlobStorage -Recurse -File | ConvertFrom-ApacheAvro

        Converts the content of all files in C:\BlobStorage from Apache Avro to custom objects.
    #>
    param (
        [parameter(Mandatory = $true,
            ValueFromPipeLine = $true,
            ValueFromPipeLineByPropertyName = $true)]
        [object]$FilePath
    )
    begin {
        $items = @()
    }
    process {
        if ($FilePath -is [System.IO.FileInfo]) {
            $FilePath = $FilePath.FullName
        }
        foreach ($path in $FilePath) {
            [System.IO.FileStream]$stream = [System.IO.FIle]::Open($Path, [System.IO.FileMode]::Open)
            
            $reader = [Microsoft.Hadoop.Avro.Container.AvroContainer]::CreateGenericReader($stream)
            while ($reader.MoveNext()) {
                foreach ($record in $reader.Current.Objects) {
                    $item = New-Object PSObject -Property @{
                        SystemProperties = @()
                        AppProperties = @()
                        Body = @()
                    }
                    if ($record.Body) {
                        try {
                            $body = [System.Text.Encoding]::UTF8.GetString($record.Body) | ConvertFrom-Json -ErrorAction Stop
                        } 
                        catch {
                            $body = New-Object PSObject -Property @{
                                StringValue =[System.Text.Encoding]::UTF8.GetString($record.Body)
                            }
                        }
                        $bodyItem = New-Object PSObject
                        foreach ($property in $body | Get-Member -MemberType NoteProperty) {
                            $bodyItem | Add-Member -Name $property.Name -Value $body.$($property.Name) -MemberType NoteProperty
                        }

                        $item.Body = $bodyItem
                    }

                    if ($record.SystemProperties) {
                        $systemPropertiesItem = New-Object PSObject
                        foreach ($key in $record.SystemProperties.Keys) {
                            $systemPropertiesItem | Add-Member -Name $key -Value $record.SystemProperties.$key -MemberType NoteProperty
                        }

                        $item.SystemProperties = $systemPropertiesItem
                    }

                    if ($record.AppProperties) {
                        $appPropertiesItem = New-Object PSObject
                        foreach ($key in $record.SystemProperties.Keys) {
                            $appPropertiesItem | Add-Member -Name $key -Value $record.SystemProperties.$key -MemberType NoteProperty
                        }

                        $item.SystemProperties = $appPropertiesItem
                    }
                }
                $items += $item
            }
            $stream.Dispose()
            $reader.Dispose()
        }
    }
    end {
        $items
    }
}
