$areWeInGitDir = start-process -FilePath git -ArgumentList ("rev-parse", "--is-inside-work-tree") -Wait -PassThru -ErrorAction SilentlyContinue
if ($areWeInGitDir.ExitCode -ne 0) {
    Write-Host "Current directory is not a git directory! Please copy this script into git directorty and launch this script again!"
    exit
}

$branches = git branch -r --no-merged
Write-Host "Number of unmerged branches ="$branches.Count

$output = @()
foreach ($branch in $branches) {
    $percentage = $branches.IndexOf($branch) * 100 / $branches.count
    Write-Progress -Activity "Collecting information about unmerged branches:" -Status "$i% Complete:" -PercentComplete $percentage
    $branch = $branch.Trim()
    $branchInfo = (git log -n 1 --format="%ci,%cr,%an,%ae,$branch" --no-merges --first-parent $branch)
    $output += $branchInfo
}

$filePath = ".\ObsoleteBranches.txt"
Write-Host "Information was added to a file:"$filePath
$output | Out-File $filePath
