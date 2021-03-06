$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

Describe "$CommandName Unit Tests" -Tag "UnitTests" {
    Context "Validate parameters" {
        [object[]]$params = (Get-ChildItem function:\Get-DbaAgHadr).Parameters.Keys
        $knownParameters = 'SqlInstance', 'SqlCredential', 'EnableException'
        It "Should contian our specifc parameters" {
            ((Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params -IncludeEqual | Where-Object SideIndicator -eq "==").Count) | Should Be $knownParameters.Count
        }
    }
}

Describe "$CommandName Integration Test" -Tag "IntegrationTests" {
    $results = Get-DbaAgHadr -SqlInstance $script:instance2
    Context "Validate output" {
        It "returns the correct properties" {
            $results.IsHadrEnabled | Should -Not -Be $null
        }
    }
}