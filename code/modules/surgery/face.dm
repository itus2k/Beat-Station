//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery/plastic_surgery
	name = "plastic surgery"
	steps = list(/datum/surgery_step/generic/cut_face, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/face/mend_vocal, /datum/surgery_step/face/fix_face,/datum/surgery_step/face/cauterize)
	possible_locs = list("head")

/datum/surgery_step/face
	priority = 2
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (!affected || (affected.status & ORGAN_ROBOT))
			return 0
		return target_zone == "mouth"

/datum/surgery_step/generic/cut_face
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/kitchenknife = 75,	\
	/obj/item/weapon/shard = 50, 		\
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		return ..() //&& target_zone == "mouth" && target.op_stage.face == 0//I NEED TO REPLACE THE OPSTAGE SHIT!

	begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].", \
		"You start to cut open [target]'s face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("\blue [user] has cut open [target]'s face and neck with \the [tool]." , \
		"\blue You have cut open [target]'s face and neck with \the [tool].",)
		//target.op_stage.face = 1//DID I MENTION I NEED TO REPLACE THE OPSTAGE SHIT!

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, slicing [target]'s throat wth \the [tool]!" , \
		"\red Your hand slips, slicing [target]'s throat wth \the [tool]!" )
		affected.createwound(CUT, 60)
		target.losebreath += 4

/datum/surgery_step/face/mend_vocal
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		return ..()// && target.op_stage.face == 1 //NO REALLY NED TO REPLACE, MAYBE WITH FUCKING istype(S.get_surgery_step(), /datum/surgery_step/cut_face)) OR SOMETHING

	begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("[user] starts mending [target]'s vocal cords with \the [tool].", \
		"You start mending [target]'s vocal cords with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("\blue [user] mends [target]'s vocal cords with \the [tool].", \
		"\blue You mend [target]'s vocal cords with \the [tool].")
		//target.op_stage.face = 2//I NEED TO REPLACE THE OPSTAGE SHIT!

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("\red [user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!", \
		"\red Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!")
		target.losebreath += 4

/datum/surgery_step/face/fix_face
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 55,	\
	/obj/item/weapon/kitchen/utensil/fork = 75)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		return ..() //&& target.op_stage.face == 2//I NEED TO REPLACE THE OPSTAGE SHIT!

	begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("[user] starts pulling skin on [target]'s face back in place with \the [tool].", \
		"You start pulling skin on [target]'s face back in place with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("\blue [user] pulls skin on [target]'s face back in place with \the [tool].",	\
		"\blue You pull skin on [target]'s face back in place with \the [tool].")
		//target.op_stage.face = 3//I NEED TO REPLACE THE OPSTAGE SHIT!

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, tearing skin on [target]'s face with \the [tool]!", \
		"\red Your hand slips, tearing skin on [target]'s face with \the [tool]!")
		target.apply_damage(10, BRUTE, affected, sharp=1, sharp=1)

/datum/surgery_step/face/cauterize
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		return ..()// && target.op_stage.face > 0//I NEED TO REPLACE THE OPSTAGE SHIT!

	begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		user.visible_message("[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool]." , \
		"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] cauterizes the incision on [target]'s face and neck with \the [tool].", \
		"\blue You cauterize the incision on [target]'s face and neck with \the [tool].")
		affected.open = 0
		affected.status &= ~ORGAN_BLEEDING
		//if (target.op_stage.face == 3)//I NEED TO REPLACE THE OPSTAGE SHIT!
		var/obj/item/organ/external/head/h = affected
		h.disfigured = 0
		h.update_icon()
		target.regenerate_icons()
		//target.op_stage.face = 0//I NEED TO REPLACE THE OPSTAGE SHIT!

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!", \
		"\red Your hand slips, leaving a small burn on [target]'s face with \the [tool]!")
		target.apply_damage(4, BURN, affected)