class ModalsController < ApplicationController
  def confirm_deletion
    @record = params[:record_type].classify.constantize.find(params[:id])

    render partial: "shared/confirmation_modal", locals: {
      title: "Confirme a exclusão!",
      message: "Esta operação é irreversível.\nTem certeza que deseja excluir?",
      url: polymorphic_path(@record)
    }
  end
end
