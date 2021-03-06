class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy]


  def index
    @posts = Post.order("id DESC").limit(20)

    if params[:max_id]
      @posts = @posts.where( "id < ?", params[:max_id])
  end

  respond_to do |format|
    format.html #如果客戶端要求 HTML, 則回傳 index.html.erb
    format.js #如果客戶端要求 Javascript,回傳 index.js.erb
  end
end


  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save


  end

  def destroy
    @post = current_user.posts.find(params[:id]) #只能刪除自己的貼文
    @post.destroy

    render :json => { :id => @post.id}
  end

  def like
    @post = Post.find(params[:id])
    unless @post.find_like(current_user) #如果已經按過讚了，就略過不再新增
      Like.create( :user => current_user, :post => @post)
  end

end

def unlike
  @post = Post.find(params[:id])
  like = @post.find_like(current_user)
  like.destroy

  render "like"
end

def collect
  @post = Post.find(params[:id])
  unless @post.find_collection(current_user)
    Collection.create!( :user => current_user, :post => @post )
  end
end


def discollect
  @post = Post.find(params[:id])
  collection = @post.find_collection(current_user)
  collection.destroy
 render "collect"
end

def toggle_flag
  @post = Post.find(params[:id])

  if @post.flag_at
    @post.flag_at = nil
  else
    @post.flag_at = Time.now
end

@post.save!

  render :json => { :message => "ok", :flag_at => @post.flag_at, :id => @post.id }
end

def rate
  @post = Post.find(params[:id])

  existing_score = @post.find_score(current_user)
  if existing_score
    existing_score.update( :score => params[:score] )
  else
    @post.scores.create( :score => params[:score], :user => current_user )
  end
  render :json => { :average_score => @post.average_score }
end


def update
  sleep(2)
  @post = Post.find(params[:id])
  @post.update!( post_params )

  render :json => { :id => @post.id, :messgae => "ok"}
end

  protected

  def post_params
    params.require(:post).permit(:content)
  end


end
