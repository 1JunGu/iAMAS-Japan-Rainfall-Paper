begin
    dq = str_get_dq()
    date_cmd   = "date +" + dq + "%a %b %d %H:%M:%S %Z %Y" + dq
    wcStrt = systemfunc(date_cmd)
;---Processing----------------
    res_path = (/"u3km","v4-60km_33N132E_785410","u60km","u60km_100s"/)
    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/"
    res_list = (/"u3km","v4-60km_33N132E","u60km_300s","u60km_100s"/)

    mesh_res = (/"u3km","rotated_4-60km_33N132E_785410","u60km","u60km"/)

    ;if(.not.isvar("ires"))then
    ;    print("Please selecet , such as: ires = 0")
    ;    exit
    ;end if

    mesh_path = "/storage/aemolcore02/jungu/mesh/"

    ires = 1

    mesh_fi = addfile(mesh_path + mesh_res(ires) + "/cell_fill.nc","r")
    lat = mesh_fi->latCell
    lon = mesh_fi->lonCell
    latvoc = mesh_fi->latvoc
    lonvoc = mesh_fi->lonvoc

    height_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/ERA5/height_500hPa.nc", "r")
    height = height_fi->height_500hPa
    uzonal_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/ERA5/uzonal_850hPa.nc", "r")
    uzonal = uzonal_fi->uzonal_850hPa
    umeridional_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/ERA5/umeridional_850hPa.nc", "r")
    umeridional = umeridional_fi->umeridional_850hPa


    ;rain_u3km@_FillValue = -999.
    ;rain_u3km = where(rain_u3km.le.7.5, rain_u3km@_FillValue,rain_u3km)
    ;cnlevels = (/ 0.5, 2., 5., 7.5, 10., 12.5, 15., 17.5,20,25/)

    ;rain_cmap = read_colormap_file("WhiteBlueGreenYellowRed")

    ;colors = rain_cmap(17:237:22,:)



    ;select region
    minlat = -6.
    maxlat = 45.
    minlon = 100.
    maxlon = 160



    N_res = 2
    wks_type = "png"
    wks_type@wkWidth  = 1024*N_res;
    wks_type@wkHeight = 1024*N_res
    ;tiMainString = "~F25~500hPa_height_diff_u60km-u3km"

;***resources for plot***
    res             = True
    ;res@gsFont = "times-roman";Time Roman
    res@gsnDraw     = False
    res@gsnFrame    = False
    res@gsnAddCyclic= False
    res@gsnMaximize = True
    ;res@gsnBoxMargin = 0.05
    res@gsnLeftString = ""
    res@gsnStringFont = 25
    res@gsnLeftStringOrthogonalPosF = 0.01
    res@gsnRightString= ""
    ;res@vpHeightF = 0.2
    res@vpWidthF  = 0.8
    ;res@tmXTOn   = False
    ;res@tmYROn   = False


    mpres = res
    mpres@mpFillOn          = True
    mpres@mpDataSetName     = "/storage/aemolcore02/jungu/Data/Earth..4/Earth..4"
    mpres@mpDataBaseVersion = "LowRes"

    mpres@mpOutlineOn       = True
    mpres@mpOutlineBoundarySets = "Geophysical"
    mpres@mpGeophysicalLineThicknessF = 2*N_res
    ;mpres@mpOutlineSpecifiers   = (/"Canada"/)
    ;mpres@mpNationalLineDashPattern = 3
    ;mpres@mpNationalLineThicknessF  = 3.8
    ;mpres@mpUSStateLineThicknessF = 17.3
    mpres@mpMinLatF = minlat
    mpres@mpMaxLatF = maxlat
    mpres@mpMinLonF = minlon
    mpres@mpMaxLonF = maxlon

    mpres@tmXTOn = False
    ;mpres@tmXBOn = False
    mpres@tmYROn = False
    ;mpres@tmYLOn = False
    mpres@tmBorderThicknessF = 2*N_res
    mpres@tmYLMajorThicknessF = 2*N_res
    mpres@tmYLMajorLengthF    = 0.006
    mpres@tmXBMajorThicknessF = 2*N_res
    mpres@tmXBMajorLengthF    = 0.006

    mpres@tmXBMinorOn = False
    mpres@tmYLMinorOn = False
    mpres@tmXBLabelDeltaF = -0.5
    mpres@tmYLLabelDeltaF = -0.5
    mpres@tmXBLabelFontHeightF = 0.013
    mpres@tmYLLabelFontHeightF = 0.013

    mpres@tmXBMode = "Explicit"
    mpres@tmXBValues = ispan(toint(minlon), toint(maxlon), 20)
    ;mpres@tmXBValues = ispan(-120, 180, 60)
    mpres@tmXBLabels = "~F25~" + abs(mpres@tmXBValues) + "~S~o~N~E"

    ;mpres@mpAreaMaskingOn = True
    ;mpres@mpMaskAreaSpecifiers       = (/"Japan"/)



    mpres@tmYLMode = "Explicit"
    mpres@tmYLValues = ispan(-20,80,20)
    YLLabels = new(6,string)
    YLLabels1 = "~F25~" + (/20/)+ "~S~o~N~S"
    YLLabels2 = "~F25~0~S~o~N~"
    YLLabels3 = "~F25~" + (/20,40,60,80/)+ "~S~o~N~N"
    YLLabels(0) = YLLabels1
    YLLabels(1) = YLLabels2
    YLLabels(2:5) = YLLabels3
    mpres@tmYLLabels = YLLabels

    mpres@mpGridAndLimbOn = False
    mpres@mpGridLatSpacingF = 10.0
    mpres@mpGridLonSpacingF = 10.0
    mpres@mpGridLineDashPattern =16
    mpres@mpGridLineThicknessF = 1.0;*N_res

    mpres@mpFillOn = False
    mpres@mpLandFillColor = "tan"
    mpres@mpOceanFillColor = "lightblue"
    mpres@mpInlandWaterFillColor = "lightblue"

    ;mpres@pmTickMarkDisplayMode = "Always"

    cnres = mpres
    cnres@cnFillDrawOrder = "Draw"
    cnres@cnInfoLabelOn   = False
    cnres@cnFillOn  = False
    cnres@cnLinesOn = True
    cnres@cnLineLabelsOn  = False
    cnres@cnLevelSelectionMode = "ExplicitLevels"
    cnres@cnLevels = (/9920/)
    ;cnres@cnMinLevelValF = 5760
    ;cnres@cnMaxLevelValF = 5940
    ;cnres@cnLevelSpacingF= 20.

    ;cnres@cnLevels = cnlevels
    ;cnres@cnFillColors = colors
    ;cnres@lbLabelBarOn = False
    ;cnres@cnFillMode = "RasterFill"
    ;cnres@trGridType = "TriangularMesh" 
    ;cnres@cnRasterSmoothingOn = True
    ;cnres@sfXArray = lon
    ;cnres@sfYArray = lat
    ;cnres@cnFillOpacityF = 0.75

    ;Set some resources for color contour lines
    ;cnres@cnMonoLineThickness   = False;Important
    ;thicknesses = (/3,3,3,3,3,7,5,5,5,5,5/)
    cnres@cnLineThicknessF = 3. * N_res
    cnres@cnLineLabelFontHeightF=0.01
    ;;cnres@cnLineDashSegLenF = 0.1
    cnres@cnLineLabelPlacementMode = "Computed"
    cnres@cnLineLabelDensityF =  1.5
    cnres@cnLineLabelInterval = 2
    ;cnres@cnInfoLabelOn = False
    ;cnres@cnMonoLineColor  = False;Important
    ;Colors = (/"Black","Black","Black","Black","Black"\
    ;            ,"Red","Black","Black","Black","Black","Black"/)
    cnres@cnLineColor     = "Red"
    ;cnres@cnMonoLineDashPattern = False
    ;patterns = (/2,2,2,2,2,5,0,0,0,0,0/)
    ;cnres@cnLineDashPatterns = patterns
    ;cnres@cnLineLabelFont = 25

    ;cnres@gsnLeftString   = "(a)"
    ;cnres@gsnLeftStringFontHeightF = 0.015
    ;;cnres@sfXArray = lon
    ;cnres@sfYArray = lat

    ;sdres = res
    ;sdres@cnFillDrawOrder = "PostDraw"
    ;sdres@cnFillOn = True
    ;sdres@cnLinesOn = False
    ;sdres@cnInfoLabelOn   = False
    ;sdres@cnLineLabelsOn  = False

    ;sdres@cnFillMode = "RasterFill"
    ;sdres@cnRasterSmoothingOn = True
    ;;sdres@sfXArray = lon
    ;;sdres@sfYArray = lat

    ;wspd_levels = ispan(4,28,4)
    ;;white_cmap = read_colormap_file"(WhiteBlueGreenYellowRed")
    ;wspd_cmap = read_colormap_file("temp_diff_18lev")
    ;wspd_colors = new((/8,4/),float)
    ;wspd_colors = wspd_cmap(9:16,:)

    ;sdres@cnLevelSelectionMode = "ExplicitLevels"
    ;sdres@cnLevels        = wspd_levels
    ;sdres@cnFillColors    = wspd_colors
    ;sdres@lbLabelBarOn    = False


    vcres                       = res
    vcres@vcGlyphStyle          = "LineArrow"
    ;vcres@vcGlyphStyle          = "CurlyVector"
    vcres@vcRefLengthF          = 0.04
    vcres@vcFillArrowFillColor  = "Black"
    vcres@vcLineArrowColor      = "Black"
    vcres@vcLineArrowThicknessF = 1.5;*N_res
    vcres@vcFillArrowEdgeThicknessF = 3;*N_res
    vcres@vcFillArrowEdgeColor  = "Black"
    vcres@vcMinDistanceF        = 0.025          ; set to small value to thin the vectors.
    vcres@vcLineArrowThicknessF = 3.            ; make the vectors thicker.
    vcres@vcVectorDrawOrder     = "PostDraw"

    vcres@vcRefAnnoOn               = False
    vcres@vcRefMagnitudeF           = 10.0
    vcres@vcRefAnnoString1          = "~F25~20"
    vcres@vcRefAnnoString2          = "[m/s]"
    vcres@vcRefLengthF              = 0.025   ; define length of vec ref
    vcres@vcRefAnnoFontHeightF      = 0.010
    vcres@vcRefAnnoFontThicknessF   = 1.
    vcres@vcRefAnnoSide             = "Top"
    ;vcres@vcRefAnnoString2On        = False
    vcres@vcRefAnnoPerimOn          = True
    vcres@vcRefAnnoOrthogonalPosF   = -0.21
    ;vcres@vcRefAnnoParallelPosF     = 0.999
    vcres@vcRefAnnoBackgroundColor  = "white"
    vcres@vcRefAnnoFont = 25
    vcres@vcRefAnnoFontHeightF = 0.013

    ;vcres@gsnRightString             = "~F25~Wind[m/s]"
    ;vcres@gsnRightStringFontHeightF  = 0.017
;***loop for draw&&frame
    wks = gsn_open_wks(wks_type,"Upper_map_v4km")
    ; Plot
    ;map = gsn_csm_map(wks,mpres)
    print("***draw contour***")
    shade = gsn_csm_contour_map(wks,height,cnres)
    print("***draw shade***")
    vector  = gsn_csm_vector(wks,uzonal({minlat:maxlat},{minlon:maxlon}),umeridional({minlat:maxlat},{minlon:maxlon}),vcres)
    print("***draw vector***")
    lat_spacing  = 10
    lon_spacing  = 10
    ;add_lc_labels(wks,contour,minlat,maxlat,minlon,maxlon,lat_spacing,lon_spacing)

    clres   = True
    clres@gsLineColor      = "navyblue"
    ;clres@gsDrawOrder 
    clres@gsLineThicknessF = 3*N_res
    clres@gsLineDashPattern    = 11

    circle    = geolocation_circle(33, 132, 14.8, 0, 180, False)
    circle_lat = circle[0]      ; For clarity: explicitly extract list elements
    circle_lon = circle[1]
    dum1 = gsn_add_polyline(wks, shade, circle_lon(0,0,:), circle_lat(0,0,:), clres)


    clres@gsLineColor      = "Red"
    circle2    = geolocation_circle(33, 132, 34, 0, 180, False)
    circle2_lat = circle2[0]      ; For clarity: explicitly extract list elements
    circle2_lon = circle2[1]
    dum2 = gsn_add_polyline(wks, shade, circle2_lon(0,0,:), circle2_lat(0,0,:), clres)
    print("***draw circle***")

    overlay(shade,vector)
    ;anno = gsn_add_annotation(contour,vector,False)
    ;overlay(contour, shade)
    print("***overlay finished***")


    draw(shade)

    frame(wks)
end 

