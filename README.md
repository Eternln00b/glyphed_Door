# glyphed Door

[EN] The first purpose of my scripts is to spoof the ".exe" extension most commonly used by backdoors with the following extensions ; ".jpg, .pdf, .png". The second purpose is to use a homoglyph character with the allowed extensions by the script.<br/><br/>The extension spoofing is a quite old attack easly detected by Windows Defender ( and probably others AV softwares ) when UTF-8 characters are used. However, the AV detection doesn't work ( I only tested with Windows Defender ) when non UTF-8 characters are used in order to spoof an .exe extension.<br/><br/>In such case, a backdoor is likely not detected by the user and can be executed without any issue. Of course, There are others mechanism enabled by most of the AV tools during the execution in order to avoid malware infection.<br/><br/>The attack effectivity is a bit limited. The scripts can rename the backdoor only under the name "annexe". If the victim OS isn't configured to unhide file extension, it's probably like not going to work. For an exemple, the user could see a file named "Annjpg".<br/><br/>I don't have the will ( and the time ) to dig this out. If you know how to solve this, it's up to you ! 

===========================================================================

[FR] Le but premier de mes scripts est de spoofer l'extension des executables ".exe" avec les extensions suivantes ; ".jpg, .pdf, .png".<br/>Le second but est d'utiliser un caractère homoglyphe avec les extensions que mes scripts permettent de choisir.<br/><br/>L'attaque "extension spoofing" est une attaque ancienne que Windows Defender ( et probablement d'autres antiviraux ) arrive à détecter quand des caractères classiques sont utilisés.<br/><br/>Quand des caractères non communs mais qui semblent similaires sont utilisés, l'attaque n'est plus détectée ( Avec Windows Defender ). Dans ce cas de figure, un backdoor avec une extension "spoofée" est exécutable sans problème.<br/><br/>La portée de l'attaque reste limitée. Les scripts peuvent uniquement renommer les backdoors en utilisant le nom "annexe". Si l'OS ciblé n'est pas configuré pour voir les extensions des fichiers, l'attaque a des chances de ne pas aboutir. L'utilisateur risque par exemple de voir un fichier dont le nom serait "AnnJpg".<br/><br/>La flemme d'y jetter un coup d'oeil, si vous étes déterminé à résoudre tout ça, bonne chance ! 
