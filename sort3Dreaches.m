function reach = sort3Dreaches(td)

%%Returns cell array with 3D reach target directions sorted

reach.Zero = td([td.target_direction] == 0);
reach.Fortyfive = td([td.target_direction] == pi/4);
reach.Ninety = td([td.target_direction] == pi/2);
reach.Onethirtyfive = td([td.target_direction] == 3*pi/4);
reach.Oneeighty = td([td.target_direction] == pi);
reach.Twotwentyfive = td([td.target_direction] == -3*pi/4);
reach.Threefifteen = td([td.target_direction] == -pi/4);

reach = struct2cell(reach);

