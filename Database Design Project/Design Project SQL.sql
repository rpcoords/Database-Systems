----------------------------------------------------------------------------------------
-- Mass Effect 2 Database
-- Database Management
-- @author Robert Coords
-- 4/22/2015
----------------------------------------------------------------------------------------

-- Drop all views
drop view if exists moralStances;

-- Drops all tables
drop table if exists characters;
drop table if exists powerTraining;
drop table if exists powers;
drop table if exists ammoTraining;
drop table if exists ammoPowers;
drop table if exists weaponTraining;
drop table if exists weapons;
drop table if exists classes;
drop table if exists backgrounds;
drop table if exists preserviceHistories;
drop table if exists psychprofiles;
drop table if exists choices;

-- SQL tables to create tables within database

-- Classes --
create table classes (
	 className		text check (className='Adept' or className='Soldier' or className='Engineer' or 
								className='Vanguard' or className='Sentinel' or className='Infiltrator'),
	 description	text,
	primary key (className)
);

-- Powers --
create table powers (
	 powerName						text not null,
	 powerType						text check (powerType='Combat' or powerType='Tech' or powerType='Biotic'),
	 description					text not null,
	 rechargeTimeInSeconds			numeric(4,2) not null,
	primary key (powerName)
);

-- PowerTraining --
-- The powers each class is trained in
create table powerTraining (
	 className		text not null references classes(className),
	 powerName		text not null references powers(powerName),
	primary key(className, powerName)
);

-- AmmoPowers --
-- NOTE: Ammunition  Powers are separate from normal powers in database, despite being grouped with all other powers in game.
-- This is because AmmoPowers are passive powers, while the powers stored within the Powers table are only active for a short period of time.
create table ammoPowers (
	 ammoPowerName					text not null,
	 description					text not null,
	 rechargeTimeInSeconds			numeric(4,2) not null,
	primary key (ammoPowerName)
);

-- AmmoTraining --
-- The AmmoPowers each class is trained to use
create table ammoTraining (
	 className		text not null references classes(className),
	 ammoPowerName	text not null references ammoPowers(ammoPowerName),
	primary key (className, ammoPowerName)
);

-- Weapons--
create table weapons (
	 weaponName		text not null,
	 baseDamage		numeric(5,2),
	primary key (weaponName)
);

-- WeaponTraining --
-- The weapons each class is trained to use
create table weaponTraining (
	 className		text not null references classes(className),
	 weaponName		text not null references weapons(weaponName),
	primary key (className, weaponName)
);

-- PreserviceHistories --
create table preserviceHistories (
	 history 		text check (history='Spacer' or history='Colonist' or history='Earthborn'),
	 description	text,
	primary key (history)
);

-- PsychProfiles --
create table psychProfiles (
	 profile		text check (profile='War Hero' or profile='Sole Survivor' or profile='Ruthless'),
	 description	text,
	primary key (profile)
);

-- Backgrounds --
create table backgrounds (
	 backgroundID					char(3) not null,
	 preserviceHistory				text not null references preserviceHistories(history),
	 psychProfile					text not null references psychProfiles(profile),
	 codexBackgroundDescription		text not null,
	primary key (backgroundID)
);

-- Choices --
-- The choices from Mass Effect 1 imported by the player. Default values available for players who did not play Mass Effect 1.
-- NOTE: virmireSurvivor has no default value, as it is dependent on character gender.
create table choices (
	 choicesID			char(4) not null,
	 rachniAlive		boolean default false,
	 wrexAlive			boolean default false,
	 virmireSurvivor	text check (virmireSurvivor='Ashley' or virmireSurvivor='Kaidan'),
	 councilAlive		boolean default false,
	 humanCouncilor		text default 'Udina' check (humanCouncilor='Anderson' or humanCouncilor='Udina'),
	primary key (choicesID)
);

-- Characters --
create table characters (
	 charID			char(4) not null,
	 firstName		text not null,
	 gender			text check (gender='male' or gender='female'),
	 className		text not null references classes(className),
	 background		char(3) not null references backgrounds(backgroundID),
	 choices		char(4) references choices(choicesID),
	 paragonPoints	integer default 0,
	 renegadePoints	integer default 0,
	primary key (charID)
);


----------------------------------------------------------------------------------------

-- Sample Data Input --

-- Classes --
insert into classes ( className, description )
	values( 'Adept', 'Adepts are outfitted with L5x implants that spawn micro-singularities, blocking enemies and pullin them into the air.' );
insert into classes ( className, description )
	values( 'Soldier', 'High-level operatives are outfitted with an ocular synaptic processor that allows them to focus on targets with lethal accuracy.' );
insert into classes ( className, description )
	values( 'Engineer', 'Engineers can spawn a combat drone to harass enemies or force them out of entrenched cover positions.' );
insert into classes ( className, description )
	values( 'Vanguard', 'Vanguards are outfitted with L5n implants that use biotic charges to knock down or stun opponents. This gives the Vanguard 
			precious seconds to bring close range wepons to bear.' );
insert into classes ( className, description )
	values( 'Sentinel', 'Sentinels are equipped with the most advanced ablation armor system to keep the Sentinel safe. If overloaded, the system stuns 
			all enemies within a short distance' );
insert into classes ( className, description )
	values( 'Infiltrator', 'Infiltrators are equipped with a tactical cloak system that allows them to avoid detection for short periods of time, gaining 
			tactical advantage over enemies.' );

-- Powers --
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Adrenaline Rush', 'Combat', 'Accelerate reflexes, granting time to line up the perfect shot.', 5.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Concussive Shot', 'Combat', 'Flatten your enemy with a precise blast at short or long range.', 6.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'AI Hacking', 'Tech', 'Allows the player to hack robotic enemies.', 6.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Cryo Blast', 'Tech', 'Flash-freeze and shatter unprotected enemies. Slow down the rest.', 4.50 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Combat Drone', 'Tech', 'Deploy this attack drone to stun targets and draw enemy fire.', 3.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Incinerate', 'Tech', 'Burn your opponents and incinerate their armor.', 6.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Overload', 'Tech', 'Overload electronics with this power surge, stunning your enemy.', 6.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Tactical Cloak', 'Tech', 'Become invisible. Gain a massive damage bonus when breaking from cloak to attack.', 6.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Tech Armor', 'Tech', 'Protect yourself with this holographic armor or detonate it to damage nearby enemies. ', 12.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Charge', 'Biotic', 'Smash into a target while encased in this biotic barrier, leveling your opponents.', 6.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Pull', 'Biotic', 'Yank an opponent helplessly off the ground.', 3.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Singularity', 'Biotic', 'Create a sphere of dark energy that traps and dangles enemies caught in its field.', 4.50 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Shockwave', 'Biotic', 'Topple a row of enemies with this cascading shockwave.', 6.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Throw', 'Biotic', 'Toss your enemy through the air with this biotic blast.', 3.00 );
insert into powers ( powerName, powerType, description, rechargeTimeInSeconds )
	values( 'Warp', 'Biotic', 'Rip your enemy apart at a molecular level.', 6.00 );

-- PowerTraining --
insert into powerTraining ( className, powerName )
	values( 'Soldier', 'Adrenaline Rush' );
insert into powerTraining ( className, powerName )
	values( 'Soldier', 'Concussive Shot' );
insert into powerTraining ( className, powerName )
	values( 'Engineer', 'AI Hacking' );
insert into powerTraining ( className, powerName )
	values( 'Infiltrator', 'AI Hacking' );
insert into powerTraining ( className, powerName )
	values( 'Engineer', 'Cryo Blast' );
insert into powerTraining ( className, powerName )
	values( 'Sentinel', 'Cryo Blast' );
insert into powerTraining ( className, powerName )
	values( 'Engineer', 'Combat Drone' );
insert into powerTraining ( className, powerName )
	values( 'Engineer', 'Incinerate' );
insert into powerTraining ( className, powerName )
	values( 'Infiltrator', 'Incinerate' );
insert into powerTraining ( className, powerName )
	values( 'Engineer', 'Overload' );
insert into powerTraining ( className, powerName )
	values( 'Sentinel', 'Overload' );
insert into powerTraining ( className, powerName )
	values( 'Infiltrator', 'Tactical Cloak' );
insert into powerTraining ( className, powerName )
	values( 'Sentinel', 'Tech Armor' );
insert into powerTraining ( className, powerName )
	values( 'Vanguard', 'Charge' );
insert into powerTraining ( className, powerName )
	values( 'Adept', 'Pull' );
insert into powerTraining ( className, powerName )
	values( 'Vanguard', 'Pull' );
insert into powerTraining ( className, powerName )
	values( 'Adept', 'Singularity' );
insert into powerTraining ( className, powerName )
	values( 'Adept', 'Shockwave' );
insert into powerTraining ( className, powerName )
	values( 'Vanguard', 'Shockwave' );
insert into powerTraining ( className, powerName )
	values( 'Adept', 'Throw' );
insert into powerTraining ( className, powerName )
	values( 'Sentinel', 'Throw' );
insert into powerTraining ( className, powerName )
	values( 'Adept', 'Warp' );
insert into powerTraining ( className, powerName )
	values( 'Sentinel', 'Warp' );

-- AmmoPowers --
insert into ammoPowers ( ammoPowerName, description, rechargeTimeInSeconds )
	values( 'Cryo Ammo', 'Flash freeze and shatter unprotected enemies.', 1.50 );
insert into ammoPowers ( ammoPowerName, description, rechargeTimeInSeconds )
	values( 'Disruptor Ammo', 'Bring down the barrier and shields of your opponents.', 1.50 );
insert into ammoPowers ( ammoPowerName, description, rechargeTimeInSeconds )
	values( 'Incendiary Ammo', 'Shoot and your enemies will burst into flames.', 1.50 );

-- AmmoTraining --
insert into ammoTraining ( className, ammoPowerName )
	values( 'Infiltrator', 'Cryo Ammo' );
insert into ammoTraining ( className, ammoPowerName )
	values( 'Soldier', 'Cryo Ammo' );
insert into ammoTraining ( className, ammoPowerName )
	values( 'Vanguard', 'Cryo Ammo' );
insert into ammoTraining ( className, ammoPowerName )
	values( 'Infiltrator', 'Disruptor Ammo' );
insert into ammoTraining ( className, ammoPowerName )
	values( 'Soldier', 'Disruptor Ammo' );
insert into ammoTraining ( className, ammoPowerName )
	values( 'Soldier', 'Incendiary Ammo' );
insert into ammoTraining ( className, ammoPowerName )
	values( 'Vanguard', 'Incendiary Ammo' );

-- Weapons --
insert into weapons ( weaponName, baseDamage )
	values( 'Assault Rifle', 10.80 );
insert into weapons ( weaponName, baseDamage )
	values( 'Sniper Rifle', 263.10 );
insert into weapons ( weaponName, baseDamage )
	values( 'Shotgun', 27.50 );
insert into weapons ( weaponName, baseDamage )
	values( 'Submachine Gun', 20.50 );
insert into weapons ( weaponName, baseDamage )
	values( 'Heavy Pistol', 37.20 );
insert into weapons ( weaponName, baseDamage )
	values( 'Heavy Weapon', 500.00 );

-- WeaponTraining --
insert into weaponTraining ( className, weaponName )
	values( 'Soldier', 'Assault Rifle' );
insert into weaponTraining ( className, weaponName )
	values( 'Soldier', 'Sniper Rifle' );
insert into weaponTraining ( className, weaponName )
	values( 'Infiltrator', 'Sniper Rifle' );
insert into weaponTraining ( className, weaponName )
	values( 'Adept', 'Submachine Gun' );
insert into weaponTraining ( className, weaponName )
	values( 'Engineer', 'Submachine Gun' );
insert into weaponTraining ( className, weaponName )
	values( 'Infiltrator', 'Submachine Gun' );
insert into weaponTraining ( className, weaponName )
	values( 'Vanguard', 'Submachine Gun' );
insert into weaponTraining ( className, weaponName )
	values( 'Sentinel', 'Submachine Gun' );
insert into weaponTraining ( className, weaponName )
	values( 'Soldier', 'Shotgun' );
insert into weaponTraining ( className, weaponName )
	values( 'Vanguard', 'Shotgun' );
insert into weaponTraining ( className, weaponName )
	values( 'Adept', 'Heavy Pistol' );
insert into weaponTraining ( className, weaponName )
	values( 'Engineer', 'Heavy Pistol' );
insert into weaponTraining ( className, weaponName )
	values( 'Infiltrator', 'Heavy Pistol' );
insert into weaponTraining ( className, weaponName )
	values( 'Vanguard', 'Heavy Pistol' );
insert into weaponTraining ( className, weaponName )
	values( 'Sentinel', 'Heavy Pistol' );
insert into weaponTraining ( className, weaponName )
	values( 'Soldier', 'Heavy Pistol' );
insert into weaponTraining ( className, weaponName )
	values( 'Adept', 'Heavy Weapon' );
insert into weaponTraining ( className, weaponName )
	values( 'Engineer', 'Heavy Weapon' );
insert into weaponTraining ( className, weaponName )
	values( 'Infiltrator', 'Heavy Weapon' );
insert into weaponTraining ( className, weaponName )
	values( 'Vanguard', 'Heavy Weapon' );
insert into weaponTraining ( className, weaponName )
	values( 'Sentinel', 'Heavy Weapon' );
insert into weaponTraining ( className, weaponName )
	values( 'Soldier', 'Heavy Weapon' );
	
-- PreserviceHistories --
insert into preserviceHistories ( history, description )
	values( 'Spacer', 'Both of your parents were in the Alliance military. Your childhood was spent on ships and stations as they transferred from posting 
			to posting, never staying in one location for more than a few years. Following in your parents footsteps, you enlisted at the age of eighteen.' );
insert into preserviceHistories ( history, description )
	values( 'Earthborn', 'You were an orphan raised on the streets of the great megatropolises covering Earth. You escaped the life of petty crime and 
			underworld gangs by enlisting with the Alliance military when you turned eighteen.' );
insert into preserviceHistories ( history, description )
	values( 'Colonist', ' You were born and raised on Mindoir, a small border colony in the Attican Traverse. When you were sixteen slavers raided Mindoir, 
			slaughtering your family and friends. You were saved by a passing Alliance patrol, and you enlisted with the military a few years later.' );

-- PsychProfiles --
insert into psychProfiles ( profile, description )
	values( 'Sole Survivor', 'During your service, a mission you were on went horribly wrong. Trapped in an extreme survival situation, you had to overcome 
			physical torments and psychological stresses that would have broken most people. You survived while all those around you fell, and now you alone 
			are left to tell the tale. His/ her unit was slaughtered in a thresher maw attack on Akuze.' );
insert into psychProfiles ( profile, description )
	values( 'War Hero', 'Early in your military career you found yourself facing an overwhelming enemy force. You risked your own life to save your fellow 
			soldiers and defeat the enemy despite the impossible odds. Your bravery and heroism have earned you medals and recognition from the Alliance fleet. 
			The War Hero almost single-handedly repelled an attack by batarian slavers on Elysium.' );
insert into psychProfiles ( profile, description )
	values( 'Ruthless', 'Throughout your military career, you have held fast to one basic rule: get the job done. You have been called cold, calculating, and 
			brutal. Your reputation for ruthless efficiency makes your fellow soldiers wary of you. But when failure is not an option, the military always goes 
			to you first. The Ruthless character sent 3/4ths of his/her unit to its death and murdered surrendering batarians on Torfan.' );

-- Backgrounds --
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b00', 'Spacer', 'Sole Survivor', 'Both of your parents were in the Alliance military. Your childhood was spent on ships and stations as they transferred 
			from posting to posting. Following in the footsteps of your parents, you enlisted at the age of eighteen. One of your first missions was an expedition to 
			investigate Akuze, a lush world on the outskirts of Alliance space that had suddenly dropped out of contact. Arriving on the surface, your patrol found the 
			settlement intact, but there were no survivors. At nightfall, the thresher maws struck - mindless abominations of teeth and tentacles that rose from beneath 
			the earth. Constant gunfire could not drown out the shrieks of your fellow soldiers as they were dragged down to a gruesome death. Fifty marines died on Akuze. 
			You were the only one to make it back to the landing zone alive. A monument on the planet commemorates the massacre, a grim reminder of the price humanity must 
			pay as they spread throughout the stars.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b01', 'Spacer', 'War Hero', 'Born into a naval family, you spent your childhood on ships and stations. You moved from posting to posting as your parents were 
			reassigned. You enlisted in the Alliance military yourself on the day you turned eighteen. You were on shore leave at Elysium when the first wave of the Skyllian 
			Blitz struck. A massive coalition force of slavers, crime syndicates, and batarian warlords attacked the human colony, determined to wipe it out. You rallied the 
			civilian inhabitants, leading them in their desperate fight to hold off the invaders. When enemy troops broke through the defenses, you single-handedly held them 
			off and sealed the breach. After hours of brutal fighting, reinforcements finally arrived and the enemy broke ranks and fled. Because of your actions, Elysium was 
			saved, and you are regarded throughout the Alliance as a true hero.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b02', 'Spacer', 'Ruthless', 'Born into a naval family, you spent your childhood on ships and stations. You moved from posting to posting as your parents were 
			reassigned, and it was only natural you would follow in their footsteps by enlisting in the Alliance military when you came of age. After several years of service, 
			you joined the campaign to rid the Skyllian Verge of batarian slavers and other criminal elements. The final battle came when Alliance forces laid siege to Torfan, 
			a slaver base built miles below the surface of a desolate moon. The superiority of the human fleet was wasted in the assault on the underground bunker, but you led 
			a corps of elite ground troops into the heart of the enemy base. Nearly three-quarters of your own squad perished in the vicious close-quarters fighting...a cost you 
			were willing to pay to make sure not a single slaver made it out of Torfan alive.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b03', 'Colonist', 'Sole Survivor', 'You were raised on Mindoir on the fringes of the Attican Traverse. When you were sixteen, the colony was raided by slavers. The 
			entire settlement was razed and your friends and family were slaughtered. A passing Alliance patrol rescued you, but all you loved was destroyed. You enlisted with 
			the Alliance military, eventually volunteering to go to Akuze, a colony that had mysteriously dropped out of contact. As soon as it arrived on the surface, your patrol 
			was attacked by thresher maws - mindless abominations of teeth and tentacles that rose up from beneath the earth. Constant gunfire could not drown out the shrieks of 
			your fellow soldiers as they were dragged down to a gruesome death. Fifty marines died on Akuze; you were the only one to make it back to the landing zone alive. A 
			monument on the planet commemorates the massacre, a grim reminder of the price humanity must pay as they spread throughout the stars.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b04', 'Colonist', 'War Hero', 'You were raised on Mindoir on the fringes of the Attican Traverse. When you were sixteen, the colony was raided by slavers. The entire 
			settlement was razed and your friends and family were slaughtered. A passing Alliance patrol rescued you, but all you loved was destroyed. You enlisted with the Alliance 
			military and were posted at Elysium. You were there during the Skyllian Blitz, an attack on the colony by a massive coalition force of slavers, crime syndicates, and 
			batarian warlords. You rallied the civilian inhabitants, leading them in their desperate fight to hold off the invaders. When enemy troops broke through the defenses for 
			the colony, you single-handedly held them off and sealed the breach. After hours of brutal fighting, reinforcements finally arrived and the enemy broke ranks and fled. 
			Because of your actions, Elysium was saved, and you are regarded throughout the Alliance as a true hero.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b05', 'Colonist', 'Ruthless', 'You were raised on Mindoir on the fringes of the Attican Traverse. When you were sixteen, the colony was raided by slavers. The entire 
			settlement was razed and your friends and family were slaughtered. A passing Alliance patrol rescued you, but all you loved was destroyed. You enlisted with the Alliance 
			military, joining the long and bloody campaign to rid the Skyllian Verge of batarian slavers and other criminal elements. The final battle came when Alliance forces laid 
			siege to Torfan, a slaver base built miles below the surface of a desolate moon. The superiority of the human fleet was wasted in the assault on the underground bunker, 
			but you led a corps of elite ground troops into the heart of the enemy base. Nearly three-quarters of your own squad perished in the vicious close-quarters fighting, a 
			cost you were willing to pay to make sure not a single slaver made it out of Torfan alive.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b06', 'Earthborn', 'Sole Survivor', 'You were born on Earth, but you never knew your parents. A child of the streets, you learned to live by your wits and guts, surviving 
			in the hidden underbelly of the megatropolises of the human homeworld. Eager to find a better life, you joined the Alliance military when you came of age. You volunteered 
			for an expedition to Akuze: a lush world on the outskirts of Alliance space that had suddenly dropped out of contact. Arriving on the surface your patrol found the settlement 
			intact, but no survivors. At nightfall, the thresher maws struck - mindless abominations of teeth and tentacles that rose up from beneath the earth. Constant gunfire could 
			not drown out the shrieks of your fellow soldiers as they were dragged down to a gruesome death. Fifty marines died on Akuze; you were the only one to make it back to the 
			landing zone alive. A monument on the planet commemorates the massacre, a grim reminder of the price humanity must pay as they spread throughout the stars.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b07', 'Earthborn', 'War Hero', 'You were born on Earth, but you never knew your parents. A child of the streets, you learned to live by your wits and guts, surviving in the 
			hidden underbelly of the megatropolises of the human homeworld. Eager to find a better life, you joined the Alliance military when you came of age. You were on shore leave at 
			Elysium when the first wave of the Skyllian Blitz struck. A massive coalition force of slavers, crime syndicates, and batarian warlords attacked the human colony, determined 
			to wipe it out. You rallied the civilian inhabitants, leading them in their desperate fight to hold off the invaders. When enemy troops broke through the defenses for the 
			colony, you single-handedly held them off and sealed the breach. After hours of brutal fighting, reinforcements finally arrived and the enemy broke ranks and fled. Because of 
			your actions, Elysium was saved, and you are regarded throughout the Alliance as a true hero.' );
insert into backgrounds ( backgroundID, preserviceHistory, psychProfile, codexBackgroundDescription )
	values( 'b08', 'Earthborn', 'Ruthless', 'You were born on Earth, but you never knew your parents. A child of the streets, you learned to live by your wits and guts, surviving in the 
			hidden underbelly of the megatropolises of the human homeworld. Eager to find a better life, you joined the Alliance military when you came of age. You were assigned to the 
			campaign to rid the Skyllian Verge of batarian slavers and other criminal elements. The final battle came when Alliance forces laid siege to Torfan, a slaver base built miles 
			below the surface of a desolate moon. The superiority of the human fleet was wasted in the assault on the underground bunker, but you led a corps of elite ground troops into 
			the heart of the enemy base. Nearly three-quarters of your own squad perished in the vicious close-quarters fighting, a cost you were willing to pay to make sure not a single 
			slaver made it out of Torfan alive.' );

-- Choices --
insert into choices ( choicesID, rachniAlive, wrexAlive, virmireSurvivor, councilAlive, humanCouncilor )
	values( 'ch00', false, false, 'Ashley', false, 'Udina' );
insert into choices ( choicesID, rachniAlive, wrexAlive, virmireSurvivor, councilAlive, humanCouncilor )
	values( 'ch01', true, false, 'Ashley', true, 'Anderson' );
insert into choices ( choicesID, rachniAlive, wrexAlive, virmireSurvivor, councilAlive, humanCouncilor )
	values( 'ch03', true, true, 'Ashley', true, 'Anderson' );
insert into choices ( choicesID, rachniAlive, wrexAlive, virmireSurvivor, councilAlive, humanCouncilor )
	values( 'ch04', false, true, 'Kaidan', false, 'Udina' );
insert into choices ( choicesID, rachniAlive, wrexAlive, virmireSurvivor, councilAlive, humanCouncilor )
	values( 'ch10', false, false, 'Kaidan', true, 'Anderson' );
insert into choices ( choicesID, rachniAlive, wrexAlive, virmireSurvivor, councilAlive, humanCouncilor )
	values( 'ch15', true, false, 'Ashley', false, 'Udina' );

-- Characters --
insert into characters ( charID, firstName, gender, className, background, choices, paragonPoints, renegadePoints )
	values( 'c000', 'John', 'male', 'Soldier', 'b00', 'ch00', 0, 0 );
insert into characters ( charID, firstName, gender, className, background, choices, paragonPoints, renegadePoints )
	values( 'c001', 'Jane', 'female',  'Soldier', 'b00', 'ch00', 0, 0 );
insert into characters ( charID, firstName, gender, className, background, choices, paragonPoints, renegadePoints )
	values( 'c003', 'R.', 'male',  'Vanguard', 'b07', 'ch01', 110, 40 );
insert into characters ( charID, firstName, gender, className, background, choices, paragonPoints, renegadePoints )
	values( 'c004', 'Jane', 'female',  'Infiltrator', 'b04', 'ch03', 170, 20 );
insert into characters ( charID, firstName, gender, className, background, choices, paragonPoints, renegadePoints )
	values( 'c006', 'Jennifer', 'female',  'Adept', 'b03', 'ch04', 150, 40 );
insert into characters ( charID, firstName, gender, className, background, choices, paragonPoints, renegadePoints )
	values( 'c010', 'Mark', 'male',  'Infiltrator', 'b04', 'ch10', 30, 100 );
insert into characters ( charID, firstName, gender, className, background, choices, paragonPoints, renegadePoints )
	values( 'c021', 'Alex', 'male',  'Engineer', 'b08', 'ch15', 95, 95 );


----------------------------------------------------------------------------------------

-- Views --

-- MoralStances
create view moralStances ( charID, firstName, paragonPoints, renegadePoints )
as
	select charID, firstName, paragonPoints, renegadePoints
	from characters;


----------------------------------------------------------------------------------------

-- Stored Procedures --

-- PowersForCharacter(id, resultset)
-- Returns the powers available to the character with the given id. The refcursor parameter is the name of the returned table.
create or replace function PowersForCharacter(char(4), refcursor) returns refcursor as 
$$
declare
	id char(4) := $1;
	resultset refcursor := $2;
begin
	open resultset for 
		select p.powerName
		from powerTraining p, characters c
		where p.className = c.className
		  and c.charID = id;
	return resultset;
end;
$$
language plpgsql;

-- WeaponsForCharacter(id, resultset)
-- Returns the weapons available to the character with the given id. The refcursor parameter is the name of the returned table.
create or replace function WeaponsForCharacter(char(4), refcursor) returns refcursor as 
$$
declare
	id char(4) := $1;
	resultset refcursor := $2;
begin
	open resultset for
		select w.weaponName
		from weaponTraining w, characters c
		where w.className = c.className
		  and c.charID = id;
	return resultset;
end;
$$
language plpgsql;

-- TotalCharactersWhoKilledWrex()
-- Returns number of characters who killed Wrex.
create or replace function TotalCharactersWhoKilledWrex() returns integer as 
$$
begin
	return (select count(cho.choicesID)
			from characters cha inner join choices cho
			  on cha.choices = cho.choicesID
			where cho.wrexAlive = false);
end;
$$
language plpgsql;


----------------------------------------------------------------------------------------

-- Triggers --



----------------------------------------------------------------------------------------

-- Security --

-- drops all role
drop role if exists admin;
drop role if exists player;
drop role if exists publicUser;

-- Admin role
-- Given all priveledges for database maintenance
create role admin;
grant insert, update, delete, select on all tables in schema public to admin;

-- Player role
-- Can add/ remove their characters from characters table.
-- Can add/ remove their choices from choices table.
-- Can view entire database.
create role player;
grant select on all tables in schema public to player;
grant insert, delete on characters to player;
grant insert, delete on choices to player;

-- Public role
-- Can only view all tables in database
create role publicUser;
grant select on all tables in schema public to publicUser;
