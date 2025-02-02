// Baseado no tutorial: https://blog.corsego.com/turbo-modal-dialog
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "frame"]  
  
  connect() {
    // Abre o modal ao conectar o controller
    this.open()
    
    // Armazena a função vinculada para que o listener possa ser removido corretamente
    this.boundEnableBodyScroll = this.enableBodyScroll.bind(this)
    
    // Adiciona o listener para o evento "close"
    this.element.addEventListener("close", this.boundEnableBodyScroll)
  }

  disconnect() {
    // Remove o listener utilizando a função vinculada armazenada
    this.element.removeEventListener("close", this.boundEnableBodyScroll)
  }

  // Fecha o modal quando a submissão do formulário for bem-sucedida
  // Exemplo de uso no HTML:
  // data-action="turbo:submit-end->dialog#submitEnd"
  submitEnd(e) {
    if (e.detail.success) {
      this.close()
      // this.element.closest('modal').close()
    }
  }

  open() {
    // Exibe o modal (supondo que this.element seja um <dialog>)
    this.element.showModal()
    // Bloqueia a rolagem da página
    document.body.classList.add('overflow-hidden')
  }

  close() {
    // Fecha o modal
    this.element.close()
    
    // Limpa o conteúdo do modal (caso esteja carregado dinamicamente)
    const frame = document.getElementById('modal')
    if (frame) {
      frame.removeAttribute("src")
      frame.innerHTML = ""
    }
    
    // Garante que a rolagem da página seja reabilitada
    this.enableBodyScroll()
  }

  enableBodyScroll() {
    document.body.classList.remove('overflow-hidden')
  }

  clickOutside(event) {
    // Se o clique ocorreu no backdrop (this.element) e não no conteúdo interno,
    // fecha o modal.
    if (event.target === this.element) {
      this.close()
    }

  }
}