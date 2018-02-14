class CategoriesController < ApplicationController
	before_action :set_category, only: [:show, :edit, :update, :destroy]
	before_action :require_admin, except: [:index, :show]

	def index
		@categories = Category.paginate(page: params[:page], per_page: 5)
	end

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)
		respond_to do |format|
		  if @category.save
		    format.html { redirect_to @category, notice: 'Category was successfully created.' }
		  else
		    format.html { render :new }
		  end
		end
	end

	def edit		
	end

    def update
      respond_to do |format|
        if @category.update(category_params)
          format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

	def show
		@category_articles = Category.find(params[:id]).articles.paginate(page: params[:page], per_page: 5)
	end

	def destroy
	    @category.destroy
	    respond_to do |format|
	      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
	    end		
	end

	private

		def set_category
			@category = Category.find(params[:id])
		end

		def category_params
			params.require(:category).permit(:name)
		end

		def require_admin
			if !is_admin?
				flash[:notice] = "You Can't do this action!"
				redirect_back fallback_location: root_path
			end
		end
end
