class Format

  STANDARD = {
    :name           => 'Standard',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    :legal_editions => [
      'Return to Ravnica',
      'Gatecrash',
      'Dragon\'s Maze',
      'Magic 2014',
      'Theros',
      'Born of the Gods'
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
      'Born of the Gods'
    ],
    :banned_cards => [
      'Ancestral Vision',
      'Ancient Den',
      'Bitterblossom',
      'Blazing Shoal',
      'Bloodbraid Elf',
      'Chrome Mox',
      'Cloudpost',
      'Dark Depths',
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
      'Vault of Whispers',
      'Wild Nacatl'
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
      'Amulet of Quoz',
      'Bronze Tablet',
      'Chaos Orb',
      'Contract from Below',
      'Darkpact',
      'Demonic Attorney',
      'Falling Star',
      'Jeweled Bird',
      'Rebirth',
      'Shahrazad',
      'Tempest Efreet',
      'Timmerian Fiends'
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
      'Amulet of Quoz',
      'Ancestral Recall',
      'Balance',
      'Bazaar of Baghdad',
      'Black Lotus',
      'Black Vise',
      'Bronze Tablet',
      'Channel',
      'Chaos Orb',
      'Contract from Below',
      'Darkpact',
      'Demonic Attorney',
      'Demonic Consultation',
      'Demonic Tutor',
      'Earthcraft',
      'Falling Star',
      'Fastbond',
      'Flash',
      'Frantic Search',
      'Goblin Recruiter',
      'Gush',
      'Hermit Druid',
      'Imperial Seal',
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
      'Mystical Tutor',
      'Necropotence',
      'Oath of Druids',
      'Rebirth',
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
      'Vampiric Tutor',
      'Wheel of Fortune',
      'Windfall',
      'Worldgorger Dragon',
      'Yawgmoth\'s Bargain',
      'Yawgmoth\'s Will',
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
    :banned_cards     => VINTAGE[:banned_cards],
    :restricted_cards => VINTAGE[:restricted_cards]
  }

  FORMATS = {
    STANDARD[:name]  => STANDARD,
    MODERN[:name]    => MODERN,
    LEGACY[:name]    => LEGACY,
    VINTAGE[:name]   => VINTAGE,
    COMMANDER[:name] => COMMANDER,
    CHALLENGE[:name] => CHALLENGE
  }

end
