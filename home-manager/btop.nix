{
  btop = {
    enable = true;
    settings = {
      theme_background = true;
      truecolor = true;
      disable_presets = "Off";
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      vim_keys = true;
      disable_mouse = true;
      terminal_sync = true;
      shown_boxes = "cpu mem proc net";
      proc_sorting = "memory";
      proc_tree = true;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = false;
      proc_filter_kernel = false;
      proc_follow_detailed = true;
      proc_aggregate = false;
      freq_mode = "range";
      zfs_arc_cached = true;
      zfs_hide_datasets = false;
      net_auto = true;
      net_sync = false;
    };
  };
}
