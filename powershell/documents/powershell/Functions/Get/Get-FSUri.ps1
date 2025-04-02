function Get-FSUri {
    [CmdletBinding()]
    param(
        [Parameter( Mandatory,
                    ValueFromPipeline )]
        [string[]] $Path,
        [switch] $AsMarkdown
    )

    process {
        foreach ($item in $Path) {
            $itemPath = (Resolve-Path $item).Path
            $SystemUri = [system.uri]::new($itemPath)

            if ($AsMarkdown) {
                $linkName = $SystemUri.LocalPath | Split-Path -LeafBase
                $output = "[{0}]({1})" -f $linkName, $SystemUri.AbsoluteUri
            }
            else {
                $output = $SystemUri.AbsoluteUri
            }
            Write-Output $output
        }
    }
}