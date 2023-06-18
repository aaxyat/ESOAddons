-- All the texts that need a translation. As this is being used as the
-- default (fallback) language, all strings that the addon uses MUST
-- be defined here.

--base language is english, so the file en.lua shuld be kept empty!
AutoCategory_localization_strings = AutoCategory_localization_strings  or {}

AutoCategory_localization_strings["es"] = {
	SI_AC_BAGTYPE_SHOWNAME_BACKPACK = "Mochila",
    SI_AC_BAGTYPE_SHOWNAME_BANK = "Banco",
    SI_AC_BAGTYPE_SHOWNAME_GUILDBANK = "Banco del gremio",
    SI_AC_BAGTYPE_SHOWNAME_CRAFTBAG = "Bolsa de materiales",
    SI_AC_BAGTYPE_SHOWNAME_CRAFTSTATION = "Estación de artesanía",
    SI_AC_BAGTYPE_SHOWNAME_HOUSEBANK = "Cofres de almacenamiento",
    SI_AC_BAGTYPE_TOOLTIP_BACKPACK = "Mochila",
    SI_AC_BAGTYPE_TOOLTIP_BANK = "Banco",
    SI_AC_BAGTYPE_TOOLTIP_GUILDBANK = "Banco del gremio",
    SI_AC_BAGTYPE_TOOLTIP_CRAFTBAG = "Bolsa de materiales",
    SI_AC_BAGTYPE_TOOLTIP_CRAFTSTATION = "Destrucción / Mejora en la estación de artesanía",
    SI_AC_BAGTYPE_TOOLTIP_HOUSEBANK = "Cofres de almacenamiento para el hogar",
    SI_AC_ALIGNMENT_LEFT = "Izquierda",
    SI_AC_ALIGNMENT_CENTER = "Centro",
    SI_AC_ALIGNMENT_RIGHT = "Derecha",

    SI_AC_DEFAULT_NAME_EMPTY_TAG = "<Vacío>",
    SI_AC_DEFAULT_NAME_CATEGORY_OTHER = "Otros",
    SI_AC_DEFAULT_NAME_NEW_CATEGORY = "NuevaCategoría",

	SI_AC_WARNING_CATEGORY_MISSING = "Falta esta categoría, asegúrese de que exista la categoría con este nombre.",
    SI_AC_WARNING_CATEGORY_NAME_EMPTY = "El nombre de la categoría no puede estar vacío",
    SI_AC_WARNING_CATEGORY_NAME_DUPLICATED = "Nombre '%s' duplicado, puedes probar '%s'.",
    SI_AC_WARNING_NEED_RELOAD_UI = "Necesario recargar UI",

    SI_AC_MENU_BS_CHECKBOX_ACCOUNT_WIDE_SETTING = "Configuración de toda la cuenta",
    SI_AC_MENU_BS_CHECKBOX_ACCOUNT_WIDE_SETTING_TOOLTIP = "Utilice la configuración de toda la cuenta en lugar de la configuración de personajes",

    SI_AC_MENU_SUBMENU_BAG_SETTING = "|c0066FF[Ajuste de la bolsa]|r",
    SI_AC_MENU_BS_DROPDOWN_BAG = "Bolsa",
	SI_AC_MENU_BS_DROPDOWN_BAG_TOOLTIP = "Seleccione una bolsa para modificar las categorías que se están utilizando",
    SI_AC_MENU_BS_CHECKBOX_UNGROUPED_CATEGORY_HIDDEN = "Ocultar elementos no agrupados",
    SI_AC_MENU_BS_CHECKBOX_UNGROUPED_CATEGORY_HIDDEN_TOOLTIP = "¡Marque esto ocultará sus artículos desagrupados, no puede encontrarlos en la configuración actual de la bolsa!",

	SI_AC_MENU_BS_DROPDOWN_CATEGORIES = "Categorías",
    SI_AC_MENU_BS_SLIDER_CATEGORY_PRIORITY = "Prioridad",
    SI_AC_MENU_BS_SLIDER_CATEGORY_PRIORITY_TOOLTIP = "La prioridad determina el orden de la categoría en la bolsa, más alto significa más posición por delante.",
    SI_AC_MENU_BS_BUTTON_EDIT = "Editar categoría",
    SI_AC_MENU_BS_BUTTON_EDIT_TOOLTIP = "Editar categoría seleccionada en la configuración de categoría.",
    SI_AC_MENU_BS_BUTTON_REMOVE = "Eliminar de la bolsa",
    SI_AC_MENU_BS_BUTTON_REMOVE_TOOLTIP = "Eliminar categoría seleccionada de la bolsa",

	SI_AC_MENU_BS_CHECKBOX_CATEGORY_HIDDEN = "Ocultar categoría",
    SI_AC_MENU_BS_CHECKBOX_CATEGORY_HIDDEN_TOOLTIP = "La categoría seleccionada y todos los artículos dentro de la categoría no aparecerán en su bolso si se registran.",

	SI_AC_MENU_HEADER_ADD_CATEGORY = "Agregar categoría",
    SI_AC_MENU_AC_DROPDOWN_TAG = "Etiqueta",
    SI_AC_MENU_AC_DROPDOWN_CATEGORY = "Categoría",
    SI_AC_MENU_AC_BUTTON_EDIT = "Editar categoría",
    SI_AC_MENU_AC_BUTTON_EDIT_TOOLTIP = "Editar categoría seleccionada en la configuración de categoría.",
    SI_AC_MENU_AC_BUTTON_ADD = "Agregar a la bolsa",
    SI_AC_MENU_AC_BUTTON_ADD_TOOLTIP = "Agregar categoría seleccionada a la bolsa",
    SI_AC_MENU_AC_BUTTON_NEED_HELP = "¿Necesita ayuda?",

	SI_AC_MENU_HEADER_IMPORT_BAG_SETTING = "Importar configuración de bolsa",
    SI_AC_MENU_IBS_DROPDOWN_IMPORT_FROM_BAG = "Importar desde bolsa",
    SI_AC_MENU_IBS_DROPDOWN_IMPORT_FROM_BAG_TOOLTIP = "Seleccione una configuración de bolsa para importar.",
    SI_AC_MENU_IBS_BUTTON_IMPORT = "Importar",
    SI_AC_MENU_IBS_BUTTON_IMPORT_TOOLTIP = "La importación sobrescribirá la configuración actual de la bolsa.",

	SI_AC_MENU_HEADER_UNIFY_BAG_SETTINGS = "Unificar todas las configuraciones de bolsas",
    SI_AC_MENU_UBS_BUTTON_EXPORT_TO_ALL_BAGS = "Exportar a todas las bolsas",
    SI_AC_MENU_UBS_BUTTON_EXPORT_TO_ALL_BAGS_TOOLTIP = "¡Reemplazará todas las configuraciones de la bolsa con la configuración actual de la bolsa!",

    SI_AC_MENU_SUBMENU_CATEGORY_SETTING = "|c0066FF[Configuración de categoría]|r",
	SI_AC_MENU_CS_DROPDOWN_TAG = "Etiqueta",
    SI_AC_MENU_CS_DROPDOWN_TAG_TOOLTIP = "Etiquete la categoría y organícelas.",
    SI_AC_MENU_CS_DROPDOWN_CATEGORY = "Categoría",

	SI_AC_MENU_HEADER_EDIT_CATEGORY = "Editar categoría",
    SI_AC_MENU_EC_EDITBOX_NAME = "Nombre",
    SI_AC_MENU_EC_EDITBOX_NAME_TOOLTIP = "El nombre no se puede duplicar",
    SI_AC_MENU_EC_EDITBOX_TAG = "Etiqueta",
    SI_AC_MENU_EC_EDITBOX_TAG_TOOLTIP = "La categoría es visible solo cuando selecciona su etiqueta. Se aplicará <Empty> si deja la etiqueta en blanco.",
    SI_AC_MENU_EC_EDITBOX_DESCRIPTION = "Descripción",
    SI_AC_MENU_EC_EDITBOX_DESCRIPTION_TOOLTIP = "Para describir para qué se usa la categoría.",
    SI_AC_MENU_EC_EDITBOX_RULE = "Regla",
    SI_AC_MENU_EC_EDITBOX_RULE_TOOLTIP = "Se aplicarán reglas a las bolsas para clasificar los artículos",
    SI_AC_MENU_EC_BUTTON_LEARN_RULES = "Aprender reglas",
    SI_AC_MENU_EC_BUTTON_LEARN_RULES_TOOLTIP = "Abrir URL de ayuda de reglas en línea",
    SI_AC_MENU_EC_BUTTON_NEW_CATEGORY = "Nuevo",
    SI_AC_MENU_EC_BUTTON_NEW_CATEGORY_TOOLTIP = "Crear una nueva categoría con la etiqueta seleccionada",
    SI_AC_MENU_EC_BUTTON_CHECK_RULE = "Verificar",
    SI_AC_MENU_EC_BUTTON_CHECK_RESULT_GOOD = "|c2DC50EBien|r",
    SI_AC_MENU_EC_BUTTON_CHECK_RESULT_ERROR = "|cFF0000Error en regla|r",
    SI_AC_MENU_EC_BUTTON_CHECK_RESULT_WARNING = "|cEECA00Advertencia - No reconocida:|r",
	SI_AC_MENU_EC_BUTTON_CHECK_RULE_TOOLTIP = "Compruebe si la regla tiene errores",
    SI_AC_MENU_EC_BUTTON_COPY_CATEGORY = "Copiar",
    SI_AC_MENU_EC_BUTTON_COPY_CATEGORY_TOOLTIP = "Hacer una nueva copia de la categoría seleccionada",
    SI_AC_MENU_EC_BUTTON_DELETE_CATEGORY = "Eliminar",
    SI_AC_MENU_EC_BUTTON_DELETE_CATEGORY_TOOLTIP = "Eliminar categoría seleccionada",

    SI_AC_MENU_SUBMENU_APPEARANCE_SETTING = "|c0066FF[Configuración de apariencia]|r",
	SI_AC_MENU_AS_DESCRIPTION_REFRESH_TIP = "Cambia la apariencia del texto del encabezado. No es necesario que recargues la interfaz de usuario, solo puedes intercambiar pestañas para actualizarlas. * SOLO funciona en modo teclado *",
    SI_AC_MENU_EC_DROPDOWN_CATEGORY_TEXT_FONT = "Fuente de texto de categoría",
    SI_AC_MENU_EC_DROPDOWN_CATEGORY_TEXT_STYLE = "Estilo de texto de categoría",
    SI_AC_MENU_EC_DROPDOWN_CATEGORY_TEXT_ALIGNMENT = "Alineación de texto de categoría",
    SI_AC_MENU_EC_DROPDOWN_CATEGORY_TEXT_COLOR = "Color de texto de categoría",
    SI_AC_MENU_EC_DROPDOWN_CATEGORY_TEXT_FONT_SIZE = "Tamaño de fuente de texto de categoría",
    SI_AC_MENU_EC_EDITBOX_CATEGORY_UNGROUPED_TITLE = "Nombre de categoría desagrupado",
    SI_AC_MENU_EC_EDITBOX_CATEGORY_UNGROUPED_TITLE_TOOLTIP = "Si ninguna categoría coincide, el artículo se incluirá en esta categoría.",
    SI_AC_MENU_EC_SLIDER_CATEGORY_HEADER_HEIGHT = "Altura del encabezado de categoría",
    SI_AC_MENU_EC_BUTTON_RELOAD_UI = "Recargar UI",

    SI_AC_MENU_SUBMENU_GENERAL_SETTING = "|c0066FF[Ajustes generales]|r",
	SI_AC_MENU_GS_CHECKBOX_SHOW_MESSAGE_WHEN_TOGGLE = "Mostrar mensaje al alternar",
    SI_AC_MENU_GS_CHECKBOX_SHOW_MESSAGE_WHEN_TOGGLE_TOOLTIP = "Mostrará un mensaje en el chat al alternar este complemento.",
    SI_AC_MENU_GS_CHECKBOX_SHOW_CATEGORY_ITEM_COUNT = "Mostrar recuento de elementos de categoría",
    SI_AC_MENU_GS_CHECKBOX_SHOW_CATEGORY_ITEM_COUNT_TOOLTIP = "Agrega un número para mostrar cuántos elementos en la categoría después del nombre de la categoría",
    SI_AC_MENU_GS_CHECKBOX_SHOW_CATEGORY_COLLAPSE_ICON = "Mostrar icono de colapso de categoría",
    SI_AC_MENU_GS_CHECKBOX_SHOW_CATEGORY_COLLAPSE_ICON_TOOLTIP = "Muestra un icono para contraer / expandir las categorías",
    SI_AC_MENU_GS_CHECKBOX_SAVE_CATEGORY_COLLAPSE_STATUS = "Guardar estado de colapso de categoría",
    SI_AC_MENU_GS_CHECKBOX_SAVE_CATEGORY_COLLAPSE_STATUS_TOOLTIP = "Mantendrá las categorías contraídas / expandidas como están después de salir / cerrar sesión.",
	SI_AC_MENU_GS_CHECKBOX_SHOW_CATEGORY_SET_TITLE = "Mostrar 'Set(name)' para autosets",
	SI_AC_MENU_GS_CHECKBOX_SHOW_CATEGORY_SET_TITLE_TOOLTIP = "Mostrar 'Set(name)' en lugar de 'nombre' en el inventario para autosets",

    SI_AC_MENU_SUBMENU_IMPORT_EXPORT = "|c0066FF[Importar y Exportar]|r",
    SI_AC_MENU_HEADER_ACCOUNT_WIDE_SETTING = "Configuración de toda la cuenta",

    SI_AC_MENU_SUBMENU_GAMEPAD_SETTING = "|c0066FF[Configuración del mando]|r",
	SI_AC_MENU_GMS_DESCRIPTION_TIP = "Solo funciona en modo gamepad",
	SI_AC_MENU_GMS_CHECKBOX_ENABLE_GAMEPAD = "Habilitar soporte de inventario",
	SI_AC_MENU_GMS_CHECKBOX_ENABLE_GAMEPAD_TOOLTIP = "Las categorías y reglas se aplicarán al inventario del mando.",
    SI_AC_MENU_GMS_CHECKBOX_EXTENDED_GAMEPAD_SUPPLIES = "Habilitar categoría de suministros extendida",
    SI_AC_MENU_GMS_CHECKBOX_EXTENDED_GAMEPAD_SUPPLIES_TOOLTIP = "La categoría de suministros contendrá todos los artículos del inventario. Se ocultarán las categorías predeterminadas de materiales, muebles y artículos que se pueden colocar.",

    SI_AC_DEFAULT_TAG_GEARS= "Equipamiento",
	SI_AC_DEFAULT_TAG_GENERAL_ITEMS = "Elementos generales",
    SI_AC_DEFAULT_TAG_MATERIALS = "Materiales",

    SI_AC_DEFAULT_CATEGORY_ARMOR= "Armadura",
    SI_AC_DEFAULT_CATEGORY_BOE= "BoE",
    SI_AC_DEFAULT_CATEGORY_BOE_DESC= "BoE equipamiento para vender",
    SI_AC_DEFAULT_CATEGORY_BOP_TRADEABLE= "BoP Intercambiable",
    SI_AC_DEFAULT_CATEGORY_BOP_TRADEABLE_DESC= "Equipamiento intercambiable en un tiempo limitado",
    SI_AC_DEFAULT_CATEGORY_DECONSTRUCT= "Deconstruir",
    SI_AC_DEFAULT_CATEGORY_DECONSTRUCT_DESC= "",
    SI_AC_DEFAULT_CATEGORY_EQUIPPING= "Equipar",
    SI_AC_DEFAULT_CATEGORY_EQUIPPING_DESC= "Equipamiento actual (Gamepad Only)",
    SI_AC_DEFAULT_CATEGORY_LOW_LEVEL= "bajo nivel",
    SI_AC_DEFAULT_CATEGORY_LOW_LEVEL_DESC= "Equipamiento por debajo de CP160",
    SI_AC_DEFAULT_CATEGORY_NECKLACE= "Colgante",
    SI_AC_DEFAULT_CATEGORY_NECKLACE_DESC= "",
    SI_AC_DEFAULT_CATEGORY_RESEARCHABLE= "Investigable",
    SI_AC_DEFAULT_CATEGORY_RESEARCHABLE_DESC= "Equipamiento que se conservan con fines de investigación, solo conservan el de baja calidad y bajo nivel.",
    SI_AC_DEFAULT_CATEGORY_RING= "Anillo",
    SI_AC_DEFAULT_CATEGORY_RING_DESC= "",
    SI_AC_DEFAULT_CATEGORY_SET= "Set",
    SI_AC_DEFAULT_CATEGORY_SET_DESC= "Auto categoriza set equipamiento",
    SI_AC_DEFAULT_CATEGORY_WEAPON= "Arma",
    SI_AC_DEFAULT_CATEGORY_WEAPON_DESC= "",
    SI_AC_DEFAULT_CATEGORY_CONSUMABLES= "Consumibles",
    SI_AC_DEFAULT_CATEGORY_CONSUMABLES_DESC= "Comida, bebida, poción",
    SI_AC_DEFAULT_CATEGORY_CONTAINER= "Contenedor",
    SI_AC_DEFAULT_CATEGORY_CONTAINER_DESC= "",
    SI_AC_DEFAULT_CATEGORY_FURNISHING= "Muebles",
    SI_AC_DEFAULT_CATEGORY_FURNISHING_DESC= "",
    SI_AC_DEFAULT_CATEGORY_GLYPHS_AND_GEMS= "Glifos y Gemas",
    SI_AC_DEFAULT_CATEGORY_GLYPHS_AND_GEMS_DESC= "",
    SI_AC_DEFAULT_CATEGORY_NEW= "Nuevo",
    SI_AC_DEFAULT_CATEGORY_NEW_DESC= "Elementos recibidos recientemente",
    SI_AC_DEFAULT_CATEGORY_POISON= "Veneno",
    SI_AC_DEFAULT_CATEGORY_POISON_DESC= "",
    SI_AC_DEFAULT_CATEGORY_QUICKSLOTS= "Quickslots",
    SI_AC_DEFAULT_CATEGORY_QUICKSLOTS_DESC= "Equipado en quickslots",
    SI_AC_DEFAULT_CATEGORY_RECIPES_AND_MOTIFS= "Recetas y Motifs",
    SI_AC_DEFAULT_CATEGORY_RECIPES_AND_MOTIFS_DESC= "Todas las recetas, motifs y fragmentos de recetas.",
    SI_AC_DEFAULT_CATEGORY_SELLING= "Venta",
    SI_AC_DEFAULT_CATEGORY_SELLING_DESC= "",
    SI_AC_DEFAULT_CATEGORY_STOLEN= "Robado",
    SI_AC_DEFAULT_CATEGORY_STOLEN_DESC= "",
    SI_AC_DEFAULT_CATEGORY_TREASURE_MAPS= "Mapas y Prospecciones",
    SI_AC_DEFAULT_CATEGORY_TREASURE_MAPS_DESC= "Mapas del tesoro e Informes de prospección",
	SI_AC_DEFAULT_CATEGORY_ALCHEMY = "Alquímia",
    SI_AC_DEFAULT_CATEGORY_ALCHEMY_DESC = "",
    SI_AC_DEFAULT_CATEGORY_BLACKSMITHING = "Herrería",
    SI_AC_DEFAULT_CATEGORY_BLACKSMITHING_DESC = "",
    SI_AC_DEFAULT_CATEGORY_CLOTHING = "Sastrería",
    SI_AC_DEFAULT_CATEGORY_CLOTHING_DESC = "",
    SI_AC_DEFAULT_CATEGORY_ENCHANTING = "Encantamiento",
    SI_AC_DEFAULT_CATEGORY_ENCHANTING_DESC = "",
    SI_AC_DEFAULT_CATEGORY_JEWELRYCRAFTING = "Elaboración de joyas",
    SI_AC_DEFAULT_CATEGORY_JEWELRYCRAFTING_DESC = "",
    SI_AC_DEFAULT_CATEGORY_PROVISIONING = "Aprovisionamiento",
    SI_AC_DEFAULT_CATEGORY_PROVISIONING_DESC = "",
    SI_AC_DEFAULT_CATEGORY_TRAIT_OR_STYLE_GEMS = "Gemas de estilo/rasgo",
    SI_AC_DEFAULT_CATEGORY_TRAIT_OR_STYLE_GEMS_DESC = "",
    SI_AC_DEFAULT_CATEGORY_WOODWORKING = "Carpintería",
    SI_AC_DEFAULT_CATEGORY_WOODWORKING_DESC = "",

    SI_BINDING_NAME_TOGGLE_AUTO_CATEGORY= "Alternar Auto Category",
    SI_MESSAGE_TOGGLE_AUTO_CATEGORY_ON="Auto Category: ON",
    SI_MESSAGE_TOGGLE_AUTO_CATEGORY_OFF="Auto Category: OFF",
    SI_CONTEXT_MENU_EXPAND = "Expandir",
    SI_CONTEXT_MENU_COLLAPSE = "Contraer",
    SI_CONTEXT_MENU_EXPAND_ALL = "Expandir TODO",
    SI_CONTEXT_MENU_COLLAPSE_ALL = "Contraer TODO",
}


