class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @user = @book.user
    @post_comment = PostComment.new
    @book.increment!(:view_count)
  end

  def index
    to  = Time.current.at_end_of_day
  from  = (to - 6.day).at_beginning_of_day
  @books = Book.all.sort {|a,b| 
    b.favorites.where(created_at: from...to).size <=> 
    a.favorites.where(created_at: from...to).size
  }
  @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :category)
  end
end