# Helper methods defined here can be accessed in any controller or view in the application

Kbase::App.helpers do

  def random_string
    rand(36**8).to_s(36)
  end

  def tags
    Tag.all
  end

  def dashboard_url
    url(:dashboard, :index)
  end

  def error(message)
    flash[:error] = message.strip
    redirect(dashboard_url)
    halt
  end

  # Bootstrap powered flash messages
  #
  def flash_message_block_for(message_type)
    return unless notice = flash[message_type]
    alert_type = case message_type
                   when :notice then 'success'
                   when :error  then 'danger'
                   else 'info'
                 end
    '<div class="alert alert-'+alert_type+' aler-dismissable">' +
      '<button type="button" class="close" data-dismiss="alert" ' +
      'aria-hidden="true">&times;</button>' +
      notice + '</div>'
  end

end
