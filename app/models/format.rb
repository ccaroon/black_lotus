class Format

  STANDARD = {
    :name           => 'Standard',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    :legal_editions => [
      'Theros',
      'Born of the Gods',
      'Journey into Nyx',
      'Magic 2015',
      'Khans of Tarkir'
    ],
    :banned_cards     => nil,
    :restricted_cards => nil
  }

  MODERN = {
    :name           => 'Modern',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    :legal_editions => [
      'Eighth Edition',
      'Mirrodin',
      'Darksteel',
      'Fifth Dawn',
      'Champions of Kamigawa',
      'Betrayers of Kamigawa',
      'Saviors of Kamigawa',
      'Ninth Edition',
      'Ravnica: City of Guilds',
      'Guildpact',
      'Dissension',
      'Coldsnap',
      'Time Spiral',
      'Planar Chaos',
      'Future Sight',
      'Tenth Edition',
      'Lorwyn',
      'Morningtide',
      'Shadowmoor',
      'Eventide',
      'Shards of Alara',
      'Conflux',
      'Alara Reborn',
      'Magic 2010',
      'Zendikar',
      'Worldwake',
      'Rise of the Eldrazi',
      'Magic 2011',
      'Scars of Mirrodin',
      'Mirrodin Besieged',
      'New Phyrexia',
      'Magic 2012',
      'Innistrad',
      'Dark Ascension',
      'Avacyn Restored',
      'Magic 2013',
      'Return to Ravnica',
      'Gatecrash',
      'Dragon\'s Maze',
      'Magic 2014',
      'Theros',
      'Born of the Gods',
      'Journey Into Nyx',
      'Magic 2015'
    ],
    :banned_cards => [
      'Ancestral Vision',
      'Ancient Den',
      'Blazing Shoal',
      'Bloodbraid Elf',
      'Chrome Mox',
      'Cloudpost',
      'Dark Depths',
      'Deathrite Shaman',
      'Dread Return',
      'Glimpse of Nature',
      'Golgari Grave-Troll',
      'Great Furnace',
      'Green Sun\'s Zenith',
      'Hypergenesis',
      'Jace, the Mind Sculptor',
      'Mental Misstep',
      'Ponder',
      'Preordain',
      'Punishing Fire',
      'Rite of Flame',
      'Seat of the Synod',
      'Second Sunrise',
      'Seething Song',
      'Sensei\'s Divining Top',
      'Stoneforge Mystic',
      'Skullclamp',
      'Sword of the Meek',
      'Tree of Tales',
      'Umezawa\'s Jitte',
      'Vault of Whispers'
    ],
    :restricted_cards => nil
  }

  VINTAGE = {
    :name           => 'Vintage',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    :legal_editions => nil,
    :banned_cards     => [
      'Advantageous Proclamation',
      'Amulet of Quoz',
      'Backup Plan',
      'Brago\'s Favor',
      'Bronze Tablet',
      'Chaos Orb',
      'Contract from Below',
      'Darkpact',
      'Demonic Attorney',
      'Double Stroke',
      'Falling Star',
      'Immediate Action',
      'Iterative Analysis',
      'Jeweled Bird',
      'Muzzio\'s Preparations',
      'Power Play',
      'Rebirth',
      'Secret Summoning',
      'Secrets of Paradise',
      'Sentinel Dispatch',
      'Shahrazad',
      'Tempest Efreet',
      'Timmerian Fiends',
      'Unexpected Potential',
      'Worldknit'
    ],
    :restricted_cards => [
      'Ancestral Recall',
      'Balance',
      'Black Lotus',
      'Brainstorm',
      'Channel',
      'Demonic Consultation',
      'Demonic Tutor',
      'Fastbond',
      'Flash',
      'Gifts Ungiven',
      'Imperial Seal',
      'Library of Alexandria',
      'Lion\'s Eye Diamond',
      'Lotus Petal',
      'Mana Crypt',
      'Mana Vault',
      'Memory Jar',
      'Merchant Scroll',
      'Mind\'s Desire',
      'Mox Emerald',
      'Mox Jet',
      'Mox Pearl',
      'Mox Ruby',
      'Mox Sapphire',
      'Mystical Tutor',
      'Necropotence',
      'Ponder',
      'Sol Ring',
      'Strip Mine',
      'Thirst for Knowledge',
      'Time Vault',
      'Time Walk',
      'Timetwister',
      'Tinker',
      'Tolarian Academy',
      'Trinisphere',
      'Vampiric Tutor',
      'Wheel of Fortune',
      'Windfall',
      'Yawgmoth\'s Bargain',
      'Yawgmoth\'s Will'
    ]
  }

  LEGACY = {
    :name           => 'Legacy',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    :legal_editions => nil,
    :banned_cards     => [
      'Advantageous Proclamation',
      'Amulet of Quoz',
      'Ancestral Recall',
      'Backup Plan',
      'Balance',
      'Bazaar of Baghdad',
      'Black Lotus',
      'Black Vise',
      'Brago\'s Favor',
      'Bronze Tablet',
      'Channel',
      'Chaos Orb',
      'Contract from Below',
      'Darkpact',
      'Demonic Attorney',
      'Demonic Consultation',
      'Demonic Tutor',
      'Double Stroke',
      'Earthcraft',
      'Falling Star',
      'Fastbond',
      'Flash',
      'Frantic Search',
      'Goblin Recruiter',
      'Gush',
      'Hermit Druid',
      'Immediate Action',
      'Imperial Seal',
      'Iterative Analysis',
      'Jeweled Bird',
      'Library of Alexandria',
      'Mana Crypt',
      'Mana Drain',
      'Mana Vault',
      'Memory Jar',
      'Mental Misstep',
      'Mind Twist',
      'Mind\'s Desire',
      'Mishra\'s Workshop',
      'Mox Emerald',
      'Mox Jet',
      'Mox Pearl',
      'Mox Ruby',
      'Mox Sapphire',
      'Muzzio\'s Preparations',
      'Mystical Tutor',
      'Necropotence',
      'Oath of Druids',
      'Power Play',
      'Rebirth',
      'Secret Summoning',
      'Secrets of Paradise',
      'Sentinel Dispatch',
      'Shahrazad',
      'Skullclamp',
      'Sol Ring',
      'Strip Mine',
      'Survival of the Fittest',
      'Tempest Efreet',
      'Time Vault',
      'Time Walk',
      'Timetwister',
      'Timmerian Fiends',
      'Tinker',
      'Tolarian Academy',
      'Unexpected Potential',
      'Vampiric Tutor',
      'Wheel of Fortune',
      'Windfall',
      'Worldgorger Dragon',
      'Worldknit',
      'Yawgmoth\'s Bargain',
      'Yawgmoth\'s Will'
    ],
    :restricted_cards => nil
  }

  CHALLENGE = {
    :name       => 'Challenge',
    :min_cards  => nil,
    :max_cards  => nil,
    :max_copies => 99
  }

  COMMANDER = {
    :name           => 'Commander',
    :alt_name       => 'Elder Dragon Highlander',
    :min_cards      => 100,
    :max_cards      => 100,
    :sideboard_size => 15,
    :max_copies     => 1,
    :legal_editions   => VINTAGE[:legal_editions],
    :banned_cards     => VINTAGE[:banned_cards] + [
      'Ancestral Recall',
      'Balance',
      'Biorhythm',
      'Black Lotus',
      'Coalition Victory',
      'Channel',
      'Emrakul, the Aeons Torn',
      'Fastbond',
      'Gifts Ungiven',
      'Karakas',
      'Library of Alexandria',
      'Limited Resources',
      'Sundering Titan',
      'Primeval Titan',
      'Sylvan Primordial',
      'Rofellos, Llanowar Emissary',
      'Erayo, Soratami Ascendant',
      'Mox Sapphire',
      'Mox Ruby',
      'Mox Pearl',
      'Mox Emerald',
      'Mox Jet',
      'Painter\'s Servant',
      'Panoptic Mirror',
      'Protean Hulk',
      'Recurring Nightmare',
      'Sway of the Stars',
      'Time Vault',
      'Time Walk',
      'Tinker',
      'Tolarian Academy',
      'Upheaval',
      'Yawgmoth\'s Bargain',
      'Griselbrand',
      'Worldfire',
      'Trade Secrets',
      'Braids, Cabal Minion'
    ],
    :restricted_cards => VINTAGE[:restricted_cards]
  }

  # Just a collection of cards
  COLLECTION = {
    :name       => 'Collection',
    :min_cards  => nil,
    :max_cards  => nil,
    :max_copies => 99   
  }

  FORMATS = {
    STANDARD[:name]   => STANDARD,
    MODERN[:name]     => MODERN,
    LEGACY[:name]     => LEGACY,
    VINTAGE[:name]    => VINTAGE,
    COMMANDER[:name]  => COMMANDER,
    CHALLENGE[:name]  => CHALLENGE,
    COLLECTION[:name] => COLLECTION
  }

end
