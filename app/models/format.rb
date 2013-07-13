class Format

  STANDARD = {
    :name           => 'Standard',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    :legal_editions => [
      'Innistrad',
      'Dark Ascension',
      'Avacyn Restored',
      'Magic 2013',
      'Return to Ravnica',
      'Gatecrash',
      'Dragon\'s Maze'
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
      'Dragon\'s Maze'
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
    # All Edition are legal
    :legal_editions => nil,
    # TODO: need list of banned and restricted cards
    :banned_cards     => [],
    :restricted_cards => []
  }

  LEGACY = {
    :name           => 'Legacy',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    # All Edition are legal
    :legal_editions => nil,
    # TODO: need list of banned cards
    :banned_cards     => [],
    :restricted_cards => nil
  }

  COMMANDER = {
    :name           => 'Commander',
    :alt_name       => 'Elder Dragon Highlander',
    :min_cards      => 100,
    :max_cards      => 100,
    :sideboard_size => 15,
    :max_copies     => 1,
    # All Edition are legal
    :legal_editions   => nil,
    :banned_cards     => nil,
    :restricted_cards => nil
  }

  FORMATS = {
    STANDARD[:name]  => STANDARD,
    MODERN[:name]    => MODERN,
    LEGACY[:name]    => LEGACY,
    VINTAGE[:name]   => VINTAGE,
    COMMANDER[:name] => COMMANDER
  }

end
