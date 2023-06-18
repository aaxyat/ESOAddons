local strings = {
--Addon LAM menu
	ARC_LAM_ADDON_DESC								= "Ricarica e Ripara Automaticamente le Armi e le Armature equipaggiate all'entrata e all'uscita da un combattimento.",
	ARC_LAM_OPTION_ACCOUNTWIDE						= "Utilizza Impostazioni per l'intero Account",
	ARC_LAM_OPTION_ACCOUNTWIDE_TT					= "Salva le impostazioni dell'addon per tutti i tuoi personaggi del tuo account, o per ogni singolo personaggio.",
	ARC_LAM_HEADER_AUTO_CHARGE						= GetString(SI_CHARGE_WEAPON_TITLE),
	ARC_LAM_OPTION_AUTO_RECHARGE						= "Automatica",
	ARC_LAM_OPTION_AUTO_RECHARGE_TT					= "Ricarica Automaticamente le tue armi quando entri o esci da un combattimento. " .. GetString(SI_CHARGE_WEAPON_CONSUME),
	ARC_LAM_OPTION_AUTO_RECHARGE_MIN_TH	 			= "Percentuale Minima",
	ARC_LAM_OPTION_AUTO_RECHARGE_MIN_TH_TT			= "Imposta un valore compreso tra 0% e 99%. Le armi saranno ricaricate quando la percentuale di carica attuale sarà uguale o inferiore a questo valore.",
	ARC_LAM_HEADER_AUTO_REPAIR						= GetString(SI_ITEM_ACTION_REPAIR) .. " " .. GetString(SI_ITEM_FORMAT_STR_ARMOR),
	ARC_LAM_OPTION_AUTO_REPAIR						= "Automatica",
	ARC_LAM_OPTION_AUTO_REPAIR_TT		   			= "Ripara automaticamente la tua armatura quando entri o esci da un combattimento. " .. GetString(SI_REPAIR_KIT_CONSUME),
	ARC_LAM_OPTION_AUTO_REPAIR_MIN_TH   				= "Percentuale Minima",
	ARC_LAM_OPTION_AUTO_REPAIR_MIN_TH_TT				= "Imposta un valore compreso tra 0% e 99%. L'armatura sarà riparata quando la percentuale della condizione attuale sarà uguale o inferiore a questo valore.",
	ARC_LAM_HEADER_CHATOUTPUT						= GetString(SI_CHAT_TAB_GENERAL),
    ARC_LAM_OPTION_SHOW_CHAT_MSG						= "Mostra in Chat",
	ARC_LAM_OPTION_SHOW_CHAT_MSG_TT					= "Mostra i messaggi nella chat se la riparazione o la ricarica delle armi non riesce, ecc.",
	ARC_LAM_OPTION_SUPPRESS_CHAT_MSG_NOTHING			= "Ignora Notifiche",
	ARC_LAM_OPTION_SUPPRESS_CHAT_MSG_NOTHING_TT		= "Non mostrare i messaggi 'Nulla da Ricaricare' o 'Nulla da Riparare'",
	ARC_LAM_HEADER_ALERT 							= "Notifiche",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT				= "Kit di Riparazione Terminati",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TT			= "Mostra un messaggio di avviso sullo schermo se i tuoi kit di riparazione sono terminati",
	ARC_LAM_OPTION_ALERT_SOON_EMPTY_REPAIRKIT		= "Kit di Riparazione in Esaurimento",
	ARC_LAM_OPTION_ALERT_SOON_EMPTY_REPAIRKIT_TT		= "Mostra un messaggio di avviso sullo schermo se la quantità dei Kit di Riparazione scende sotto la soglia.\n\nImposta la tua soglia sul cursore a destra!",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TH			= "Soglia Kit di Riparazione",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TH_TT		= "Imposta un valore compreso tra 1 e 100 per i Kit di Riparazione. Se lasci il combattimento e i tuoi Kit di Riparazione scendono sotto questo valore, riceverai un messaggio di avviso sullo schermo.",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_LOGIN		= "Notifica Kit di Riparazione all'accesso/reloadui",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_LOGIN_TT	= "Quando si accede o si fa un reloadui:\nMostra un messaggio di avviso sullo schermo se il numero dei Kit di Riparazione scende sotto la soglia scelta o è già 0.",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_VENDOR		= "Notifica Kit di Riparazione all'accesso/ricarica",
	ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_VENDOR_TT	= "Quando si accede o si fa un reloadui:\nMostra un messaggio di avviso sullo schermo se il numero dei Kit di Riparazione scende sotto la soglia scelta o è già 0.",
	ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM				= "Gemme dell'Anima Terminate",
	ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TT			= "Mostra un messaggio di avviso sullo schermo se le tue Gemme dell'Anima sono terminate",
	ARC_LAM_OPTION_ALERT_SOON_EMPTY_SOULGEM			= "Gemme dell'Anima in Esaurimento",
	ARC_LAM_OPTION_ALERT_SOON_EMPTY_SOULGEM_TT		= "Mostra un messaggio di avviso sullo schermo se la tua quantità di gemme dell'anima scende sotto la soglia.\n\nImposta la tua soglia sul cursore a destra!",
	ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TH			= "Soglia Gemme dell'Anima",
	ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TH_TT			= "Imposta un valore compreso tra 1 e 100 per le Gemme dell'Anima. Se lasci il combattimento e le tue Gemme dell'Anima scendono sotto questo valore, riceverai un messaggio di avviso sullo schermo.",
	ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_LOGIN	  		= "Notifica Gemme dell'Anima all'accesso/reloadui",
	ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_LOGIN_TT		= "Quando si accede o si fa un reloadui:\nMostra un messaggio di avviso sullo schermo se il numero delle tue Gemme dell'Anima scende sotto la soglia scelta o è già 0.",
	ARC_LAM_OPTION_SHOW_REPAIR_KITS_LEFT_AT_VENDOR	= "Mostra Kit di Riparazione dal Venditore",
	ARC_LAM_OPTION_SHOW_REPAIR_KITS_LEFT_AT_VENDOR_TT= "Mostra i Kit di Riparazione rimasti, dopo aver parlato con un venditore, visualizza una piccola icona con accanto il numero di Kit di Riparazione rimasti.",
	ARC_LAM_OPTION_USE_REPAIR_KITS_FOR_ITEM_LEVEL	= "Usa Kit di Riparazione del Livello dell'Oggetto",
	ARC_LAM_OPTION_USE_REPAIR_KITS_FOR_ITEM_LEVEL_TT = "Se possiedi diversi Kit di Riparazione, verrà utilizzato quello appropriato al livello dell'oggetto (ad esempio 'grande kit' per gli oggetti con CP 160), riparando le condizioni del tuo oggetto almeno per il 90%",
	ARC_LAM_OPTION_DO_NOT_USE_CROWN_STORE_REPAIR_KITS= "Preserva Kit di Riparazione del Negozio delle Corone",
	ARC_LAM_OPTION_DO_NOT_USE_CROWN_STORE_REPAIR_KITS_TT = "Con questa impostazione abilitata, nessun Kit di Riparazione del Negozio delle Corone sarà utilizzato per le riparazioni automatiche.",

	ARC_LAM_OPTION_AUTO_RECHARGE_IN_COMBAT			= "In Combattimento",
	ARC_LAM_OPTION_AUTO_RECHARGE_IN_COMBAT_TT		= "Ricarica automaticamente le tue armi anche durante il combattimento",
	ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE		= "Ricarica Cambio Arma",
	ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_TT	= "Controlla e ricarica le armi durante il cambio delle armi.",
	ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_ONLY_IN_COMBAT = "Controllo Cambio Arma: Solo in combattimento",
	ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_ONLY_IN_COMBAT_TT = "Effettua la ricarica dopo il controllo del cambio arma solo se si è in combattimento",
	ARC_LAM_OPTION_AUTO_REPAIR_IN_COMBAT				= "In Combattimento",
	ARC_LAM_OPTION_AUTO_REPAIR_IN_COMBAT_TT		   	= "Ripara automaticamente la tua armatura anche durante il combattimento",

--Chat output messages
	ARC_CHATOUTPUT_CHARGED							= "Ricaricata: ",
	ARC_CHATOUTPUT_CHARGED_NOTHING	   				= "Nulla da Ricaricare: ",
	ARC_CHATOUPUT_NO_CHARGEABLE_WEAPONS				= GetString(SI_SOULGEMITEMCHARGINGREASON1),
	ARC_CHATOUTPUT_REPAIRED							= "Riparato: ",
	ARC_CHATOUTPUT_REPAIRED_NOTHING					= "Nulla da Riparare: ",
	ARC_CHATOUPUT_NO_REPAIRABLE_ARMOR				= GetString(SI_NO_REPAIRS_TO_MAKE),

	ARC_CHATOUPUT_MIN_CHARGE 						= GetString(SI_GRAPHICSPRESETS0) .. " " .. GetString(SI_CHARGE_WEAPON_CONFIRM) .. ": ",
	ARC_CHATOUPUT_MIN_CONDITION 						= GetString(SI_GRAPHICSPRESETS0) .. " " .. GetString(SI_REPAIR_SORT_TYPE_CONDITION) .. ": ",
	ARC_CHATOUPUT_INVALID_PERCENTAGE					= "Percentuale non valida: <<C:1>>, intervallo: 0-99.",
	ARC_CHATOUPUT_CHARGE								= GetString(SI_CHARGE_WEAPON_CONFIRM) .. " ",
	ARC_CHATOUPUT_REPAIR								= GetString(SI_REPAIR_KIT_TITLE) .. " ",
    ARC_CHATOUPUT_SETTINGS_ENABLED					= GetString(SI_ADDON_MANAGER_ENABLED),
    ARC_CHATOUPUT_SETTINGS_DISABLED					= GetString(SI_CHECK_BUTTON_DISABLED),

	ARC_CHATOUPUT_REPAIRKITS_EMPTY_THRESHOLD			= "Soglia dei Kit di Riparazione terminati: ",
    ARC_CHATOUPUT_SOULGEMS_EMPTY_THRESHOLD			= "Soglia delle Gemme dell'Anima terminate: ",

--Alert messages
	ARC_ALERT_REPAIRKITS_EMPTY						= "I Kit di Riparazione sono terminati!",
	ARC_ALERT_REPAIRKITS_SOON_EMPTY					= "I Kit di Riparazione sono quasi terminati! Ne restano solo <<C:1>>!",
	ARC_ALERT_SOULGEMS_EMPTY							= "Le Gemme dell'Anima sono terminate!",
	ARC_ALERT_SOULGEMS_SOON_EMPTY					= "Le Gemme dell'Anima sono quasi terminate! Ne restano solo <<C:1>>!",

--Keybindings
    SI_KEYBINDINGS_CATEGORY_RECHARGE                    = "Ricarica Automatica",
    SI_BINDING_NAME_RUN_RECHARGE                        = "Attiva Ricarica Automatica e Riparazione Automatica",
	SI_BINDING_NAME_RUN_REPAIR_SINGLE					= "Attiva Riparazione Automatica",
	SI_BINDING_NAME_RUN_RECHARGE_SINGLE					= "Attiva Ricarica Automatica",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
