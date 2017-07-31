class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy]


  def index
    @posts = Post.order("id DESC").all #新貼文放前面
  end


  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save


  end

  def destroy
    @post = current_user.posts.find(params[:id]) #只能刪除自己的貼文
    @post.destroy


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
  unless @post.find_collect(current_user)
    Collection.create( :user => current_user, :post => @post)
  end
render "collection"
end


def uncollect
  @post = Post.find(params[:id])
  collection = @post.find_collect(current_user)
  collection.destroy
 render "collection"
end


  protected

  def post_params
    params.require(:post).permit(:content)
  end


end
