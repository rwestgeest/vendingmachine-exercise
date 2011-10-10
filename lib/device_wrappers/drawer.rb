class PhysicalDrawer 
  def initialize(drawer_no)
    @drawer_no = drawer_no
  end
  def drop_can
    Devices.drawer_drop_can(@drawer_no)
  end
end


