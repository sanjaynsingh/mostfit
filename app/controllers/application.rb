class Application < Merb::Controller
  before :ensure_authenticated

  def ensure_has_data_entry_privileges
    raise NotPrivileged unless session.user.data_entry_operator? || session.user.mis_manager? || session.user.admin?
  end

  def ensure_has_mis_manager_privileges
    raise NotPrivileged unless session.user.mis_manager? || session.user.admin?
  end

  def ensure_has_admin_privileges
    raise NotPrivileged unless session.user.admin?
  end

  def render_to_pdf(options = nil)
    data = render_to_string(options)
    pdf = PDF::HTMLDoc.new
    pdf.set_option :bodycolor, :white
    pdf.set_option :toc, false
    pdf.set_option :portrait, true
    pdf.set_option :links, false
    pdf.set_option :webpage, true
    pdf.set_option :left, '2cm'
    pdf.set_option :right, '2cm'
    pdf << data
    pdf.generate
  end
end


# small monkey patch, real patch is submitted to extlib/merb/dm, hoping for inclusion soon
class Date
  def inspect
    "<Date: #{self.to_s}>"
  end
end
