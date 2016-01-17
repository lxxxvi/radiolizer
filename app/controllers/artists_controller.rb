class ArtistsController < ApplicationController
  def index
    @artists = Artist.all.order(:name)
  end

  def show
    @artist = Artist.find( params[:id] )
  end

  def alphabet
    case params[ :character ]
      when '0-9' then @artists = Artist.only_parents.where( "name REGEXP '^[[:digit:]].*'" ).ordered
      when '!?#' then @artists = Artist.only_parents.where( "name REGEXP '^[[:punct:]].*'" ).ordered
      else            @artists = Artist.only_parents.where( 'name LIKE ?', "#{params[ :character ]}%" ).ordered
    end
  end

  def same_as
    parent = Artist.find( params[:parent_id] )
    child = Artist.find( params[:id] )
    child.same_as!( parent )
    redirect_to action: 'show', id: parent.id
  end

  def capitalize
    artist = Artist.find( params[:id] )
    artist.update!( name: artist.name.capitalize_all )
    redirect_to action: 'show', id: artist.id
  end

  private
end
