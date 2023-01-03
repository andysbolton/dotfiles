function Remove-Package($Package) {
    $packages = Get-AppxPackage $Package -AllUsers 
    if ($null -eq $packages) {
        return
    }
    $packages | Remove-AppxPackage -AllUsers
    Get-AppXProvisionedPackage -Online | Where-Object DisplayName -like $Package | Remove-AppxProvisionedPackage -Online -AllUsers
}

(
    "*.AutodeskSketchBook",
    "*.DisneyMagicKingdoms",
    "*.MarchofEmpires",
    "*.SlingTV",
    "*.TikTok",
    "*.Twitter",
    "AdobeSystemsIncorporated.AdobeCreativeCloudExpress",
    "AmazonVideo.PrimeVideo",
    "Clipchamp.Clipchamp",
    "Disney*",
    "DolbyLaboratories.DolbyAccess",
    "Facebook.Facebook*",
    "Facebook.Instagram*",
    "king.com.BubbleWitch3Saga",
    "king.com.CandyCrushSodaSaga",
    "Microsoft.3DBuilder",
    "Microsoft.549981C3F5F10",
    "Microsoft.BingFinance",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingWeather",
    "Microsoft.GamingApp",
    "Microsoft.Messaging",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.Office.OneNote",
    "Microsoft.Office.Sway",
    "Microsoft.OneConnect",
    "Microsoft.Paint",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.ToDos",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCommunicationsApps",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "SpotifyAB.SpotifyMusic",
    "Microsoft.XboxIdentityProvider",
    "*.Netflix"
) | ForEach-Object { Remove-Package -Package $_ }
