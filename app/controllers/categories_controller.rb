class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  LIMIT_PER_PAGE = [ 10, 20, 30, 40, 50, 100 ].freeze
  def index
    per_page = if params[:limit].present? && LIMIT_PER_PAGE.include?(params[:limit].to_i)
      params[:limit].to_i
    else
      10 # valor padrão
    end

    @search = Category.all.ransack(params[:q])
    @pagy, @categories = pagy(@search.result, limit: per_page)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        flash.now[:notice] = "Categoria salva com sucesso!"

        format.html { redirect_to @category }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "shared/flash")
          ]
        end
      else
        flash.now[:alert] = "Houve um erro ao salvar o cliente."

        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("flash",
                                                    partial: "shared/flash")
        end
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to @category
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@category)
      end
      format.html { redirect_to categories_path, notice: "Categoria excluída." }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.expect(category: %i[name])
  end
end
