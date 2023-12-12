var/datum/subsystem/lighting/SSlighting

var/list/lighting_update_lights = list() // List of lighting sources  queued for update.
var/init_lights = list()

/datum/subsystem/lighting
	name          = "Lighting"
	init_order    = SS_INIT_LIGHTING
	display_order = SS_DISPLAY_LIGHTING
	wait          = 1
	priority      = SS_PRIORITY_LIGHTING
	flags         = SS_TICKER

	var/list/currentrun_lights

	var/resuming = 0


/datum/subsystem/lighting/New()
	NEW_SS_GLOBAL(SSlighting)

/datum/subsystem/lighting/stat_entry()
	..("L:[lighting_update_lights.len] queued")

/datum/subsystem/lighting/Initialize(timeofday)
	// Lighting stuff
	//initialise_lights()
	for(var/atom/movable/light/L in init_lights)
		if(!L.gcDestroyed)
			L.cast_light()
	init_lights = null
	initialized = TRUE
	..()

/datum/subsystem/lighting/fire(resumed=FALSE)
	if (!resumed)
		currentrun_lights   = lighting_update_lights
		lighting_update_lights   = list()

	while (currentrun_lights.len)
		var/atom/movable/light/L = currentrun_lights[currentrun_lights.len]
		currentrun_lights.len--

		if(L && !L.gcDestroyed)
			L.cast_light()

		if (MC_TICK_CHECK)
			return

/datum/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
	..()

/proc/initialise_lights()
	to_chat(world, "<span class='userdanger'>Lights initialised...</span>")
	world.log << "Lights initialised..."
	if (!lighting_engine)
		lighting_engine = new lighting_system_used
