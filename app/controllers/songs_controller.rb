class SongsController < ApplicationController
  def show
    @song = Song.find( params[:id] )
  end

  def same_as
    parent = Song.find( params[:parent_id] )
    child = Song.find( params[:id] )
    child.same_as!( parent )
    redirect_to action: 'show', id: parent.id
  end

  def capitalize
    song = Song.find( params[:id] )
    song.update!( name: song.name.capitalize_all )
    redirect_to action: 'show', id: song.id
  end
end
