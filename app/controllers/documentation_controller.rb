class DocumentationController < ApplicationController

  def quick_start
    @server    = Server.official
    @schematic = Schematic.order('random()').first
  end

  def server_setup
    @uuid = UUID.generate(:compact)
  end

  def character_claims
    @server     = Server.official
    @claim_code = CHARACTER_CLAIM_HASHIDS.encode(0)
    @character  = Character.find_by_username "onebert"
  end

end
