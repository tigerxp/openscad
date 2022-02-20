ball_dia = 1.5;
ball_tol = 0.125;
wall_thickness = 0.0625;
back_thickness = 0.125;
height = 6;

bend_radius = ball_dia*3/4;
shoot_len = ball_dia*0.6;

slit_size = 0.625;
eject_hole = 0.375;

screw_clearance_hole = 0.150;
screw_head = .300;

module tangent_base( r, b, h ) {
  rotate( [ 0, 90, 0 ] )
  linear_extrude( height = h )
    polygon( [ [ -b - r/2, -sqrt(3)/2*r ],
               [ -b - r/2,  sqrt(3)/2*r ],
               [ 0,        sqrt(3)/3*( r - b ) ],
               [ 0,       -sqrt(3)/3*( r - b ) ] ] );
}

module toroid( bend_radius, dia ) {
  intersection () { 
      rotate ( [ 90, 0, 0 ] ) rotate_extrude( convexity = 10, $fn = 72 ) translate( [ bend_radius, 0, 0 ] ) circle( r = dia/2, $fn = 36 );
      translate( [ -bend_radius - dia/2 - 0.1, -dia/2 - 0.1, -bend_radius - dia/2 - 0.1 ] ) cube( [ bend_radius + dia/2 + 0.1, dia + 0.2, bend_radius + dia/2 + 0.1 ] );
      rotate ( [ 0, -30, 0 ] ) translate( [ -bend_radius - dia/2 - 0.1, -dia/2 - 0.1, -bend_radius - dia/2 - 0.1 ] ) cube( [ bend_radius + dia/2 + 0.1, dia + 0.2, bend_radius + dia/2 + 0.1 ] );
  }
}

function tt_mt( m, phi ) = m / cos( phi );
function tt_xmt( R, r, mt ) = ( mt * R + sqrt( ( mt*mt + 1 ) * r*r - R*R ) ) / ( mt*mt + 1 );
function tt_point( R, r, h, m, phi ) = tt_xmt( R, r, tt_mt( m, phi ) ) * [ 1, m, -m*tan( phi ) ] + [ 0, 0, h ];

function tt_critical_ang( k, m ) = m < sqrt(k*k-1) ? acos( m/sqrt(k*k-1) ) : 0;
function tt_invslope2( k, m, phi, cos_sqr_phi ) = sqrt(m*m+1)*(k*sqrt(m*m-(k*k-1)*cos_sqr_phi)+m*(k*k*cos_sqr_phi-m*m-1))*tan(phi)/(m*m*(k*k*cos_sqr_phi-m*m-2)+k*k-1);
function tt_invslope( k, m, phi ) = tt_invslope2( k, m, phi, cos( phi )*cos( phi ) );
function tt_invslopev( k, m, phi ) = [ phi, tt_invslope( k, m, phi ) ];

function tt_interp( a, b, des ) = a[1]==b[1]?a[0]:(des-a[1])/(b[1]-a[1])*(b[0]-a[0])+a[0];

function tt_find_phi_interp( count, k, m, des, ps, ps_old ) =
  abs(ps[0]-ps_old[0]) < 1e-14 * abs(ps[0]) || count >= 30 ?
    tt_interp( ps, ps_old, des ) :
    //[ count, ps, ps_old ] :
    tt_find_phi_interp( count + 1, k, m, des, tt_invslopev( k, m, tt_interp( ps, ps_old, des ) ), ps );

function tt_find_phi_bisect_helper( count, k, m, des, ps1, ps2, ps_new ) =
  ps_new[1] > des ?
    tt_find_phi_bisect_loop( count + 1, k, m, des, ps1, ps_new ) :
    tt_find_phi_bisect_loop( count + 1, k, m, des, ps_new, ps2 );

function tt_find_phi_bisect_loop( count, k, m, des, ps1, ps2 ) =
  count >= 7 ?
    tt_find_phi_interp( 0, k, m, des, ps1, ps2 ) :
    //[ ps1, ps2 ] :
    tt_find_phi_bisect_helper( count, k, m, des, ps1, ps2, tt_invslopev( k, m, (ps1[0]+ps2[0])/2 ) );

function tt_find_phi_bisect( k, m, des, phi1, phi2 ) =
  tt_find_phi_bisect_loop( 0, k, m, des, tt_invslopev( k, m, phi1 ), tt_invslopev( k, m, phi2 ) );

function tt_find_phi( R, r, m, des_slope ) = m==0?90:tt_find_phi_bisect( R/r, m, des_slope, tt_critical_ang( R/r, m )*(1.00000001)+1e-10, 0.9999999999 * 90 );

function tt_tangent_point( R, r, h, m, des_slope ) = m==0?[r/des_slope/sqrt(1/des_slope/des_slope+1),0,h-R-r/sqrt(1/des_slope/des_slope+1)]:tt_point( R, r, h, m, tt_find_phi( R, r, m, des_slope ) );

function tt_add_bottom_point( tangent_point, m, des_slope ) = [ tangent_point, [tangent_point[0],tangent_point[1],0]-tangent_point[2]*des_slope/sqrt(1+m*m)*[1,m,0] ];

function tt_points( R, r, h, m, des_slope ) = tt_add_bottom_point( tt_tangent_point( R, r, h, m, des_slope ), m, des_slope );

echo( tt_invslope( 3/2, tan(50), 0.999999999 * 90 ), tt_point( 3, 2, tan(50), 30 ) );

echo( tt_critical_ang( 3/2, tan(10) ), tt_find_phi( 3, 2, tan(55), 1/sqrt(3) ) );

echo( tt_points( 3, 2, 5, tan(50), 1/sqrt(3) ) );

function tt_mp( p ) = [ -p[0], p[1], p[2] ]; // mirror point

module tt_slice_from_points( R, r, h, pair1, pair2 ) {
   polyhedron( points = [ pair1[0], pair1[1], pair2[0], pair2[1],
                          tt_mp( pair1[0] ), tt_mp( pair1[1] ), tt_mp( pair2[0] ), tt_mp( pair2[1] ),
                          [ 0, 2*pair1[1][1]-pair2[1][1], pair1[0][2]/2 ] ],
               triangles = [ [ 0, 3, 1 ], [ 0, 2, 3 ], [ 1, 3, 7 ], [ 1, 7, 5 ], [ 4, 7, 6 ], [ 4, 5, 7 ], [ 0, 4, 6 ], [ 0, 6, 2 ], [ 6, 3, 2 ], [ 6, 7, 3 ], [ 4, 0, 8 ], [ 0, 1, 8 ], [ 1, 5, 8 ], [ 4, 8, 5 ] ],
               convexity = 3 );
}

module tt_slice( R, r, h, m1, m2, des_slope ) {
  tt_slice_from_points( R, r, h, tt_points( R, r, h, m1, des_slope ), tt_points( R, r, h, m2, des_slope ) );
}

module tt_base( R, r, h, num ) {
  for ( ang = [ 0 : num - 1 ] ) {
    tt_slice( R, r, h, tan( ang * 90 / num ), tan( ( ang + 1 ) * 90 / num ), 1/sqrt(3) );
  }
}

module slits( angle ) {
  translate ( [ slit_size, 0, ball_dia/2 + ball_tol/2 + back_thickness ] ) rotate( [ angle, 0, 0 ] ) translate( [ 0, -slit_size/2, 0 ] ) cube( [ height/2 - slit_size * 3/2, slit_size, ball_dia ] );
  translate ( [ height/2 + slit_size/2, 0, ball_dia/2 + ball_tol/2 + back_thickness ] ) rotate( [ angle, 0, 0 ] ) translate( [ 0, -slit_size/2, 0 ] ) cube( [ height/2 - slit_size * 3/2, slit_size, ball_dia ] );
}

module screw() {
  translate( [ 0, 0, -ball_dia ] ) cylinder( r = screw_clearance_hole/2, h = ball_dia, $fn = 18 );
  translate( [ 0, 0, 0.001 - ( screw_head/2-screw_clearance_hole/2 ) ] ) cylinder( r2 = screw_head/2, r1 = screw_clearance_hole/2, h = screw_head/2-screw_clearance_hole/2, $fn = 18 );
  cylinder( r = screw_head/2, h = 4 * ball_dia + shoot_len, $fn = 18 );
}

rotate( [ 0, 0, 45 ] )
scale ( 25.4 ) {
  difference () {
    union ()  {
      translate( [ -0.001, 0, ball_dia/2 + ball_tol/2 + back_thickness ] ) rotate( [ 0, 90, 0 ] ) cylinder( r = ball_dia/2 + ball_tol/2 + wall_thickness, h = height + 0.001, $fn = 36 );
      tangent_base( ball_dia/2 + ball_tol/2 + wall_thickness, back_thickness - wall_thickness, height );
      translate( [ 0, 0, bend_radius + ball_dia/2 + ball_tol/2 + back_thickness ] ) toroid( bend_radius, ball_dia + ball_tol + 2 * wall_thickness );
      translate ( [ -sqrt(3)/2*bend_radius + 0.001 / 2, 0, bend_radius / 2 + ball_dia/2 + ball_tol/2 + back_thickness - 0.001 * sqrt(3)/2 ] ) rotate ( [ 0, -30, 0 ] ) cylinder( r = ball_dia/2 + ball_tol/2 + wall_thickness, h = shoot_len + 0.002, $fn = 36 );
      translate( [ -sqrt(3)/2*bend_radius - shoot_len/2, 0, bend_radius / 2 + ball_dia/2 + ball_tol/2 + back_thickness + shoot_len*sqrt(3)/2 ] ) rotate( [ 0, -30, 0 ] ) sphere( r = ball_dia/2 + ball_tol/2 + wall_thickness, $fn = 36 );
      rotate( [ 0, 0, 90 ] ) tt_base( bend_radius, ball_dia/2 + ball_tol/2 + wall_thickness, bend_radius + ball_dia/2 + ball_tol/2 + back_thickness, 18 );
      translate ( [ height - slit_size, 0, ball_dia/2 + ball_tol/2 + back_thickness ] ) rotate ( [ 0, 90, 0 ] ) cylinder( r = ball_dia/2 + ball_tol/2 + 2 * wall_thickness, h = slit_size, $fn = 36 );
      translate ( [ height - slit_size, 0, 0 ] ) tangent_base( ball_dia/2 + ball_tol/2 + back_thickness, 0, slit_size );
//      translate ( [ -1.1, 0, 0 ] ) cylinder( r = 0.75, h = 0.040, $fn = 18 );
//      translate ( [ height, 0, 0 ] ) cylinder( r = 1, h = 0.040, $fn = 18 );
    }
    translate( [ -0.001, 0, ball_dia/2 + ball_tol/2 + back_thickness ] ) rotate( [ 0, 90, 0 ] ) cylinder( r = ball_dia/2 + ball_tol/2, h = height + 0.2, $fn = 36 );
    translate( [ 0, 0, bend_radius + ball_dia/2 + ball_tol/2 + back_thickness ] ) toroid( bend_radius, ball_dia + ball_tol );
    translate ( [ -sqrt(3)/2*bend_radius + 0.001 / 2, 0, bend_radius / 2 + ball_dia/2 + ball_tol/2 + back_thickness - 0.001 * sqrt(3)/2 ] ) rotate ( [ 0, -30, 0 ] ) cylinder( r = ball_dia/2 + ball_tol/2, h = shoot_len + 0.002, $fn = 36 );
    translate( [ -sqrt(3)/2*bend_radius - shoot_len/2, 0, bend_radius / 2 + ball_dia/2 + ball_tol/2 + back_thickness + shoot_len*sqrt(3)/2 ] ) rotate( [ 0, -30, 0 ] ) sphere( r = ball_dia/2 + ball_tol/2, $fn = 36 );
    translate( [ -ball_dia/4 - shoot_len/2, 0, bend_radius + ball_dia/2 + ball_tol/2 + back_thickness + (shoot_len-0.5)*sqrt(3)/2 ] )
      rotate( [ 0, 60, 0 ] )
        union () {
           translate( [ 0, 0, 1.5 * ball_dia ] ) cube( [ ball_dia + 2*ball_tol, 3 * ball_dia, 3 * ball_dia ], center = true );
           rotate( [ 90, 0, 0 ] ) cylinder( r = ball_dia/2 + ball_tol, h = 3 * ball_dia, $fn = 36, center = true );
        }
    translate ( [ -sqrt(3)/2*bend_radius - shoot_len/2, 0, bend_radius / 2 + ball_dia/2 + ball_tol/2 + back_thickness + shoot_len*sqrt(3)/2 ] ) rotate( [ 0, -120, 0 ] ) cylinder( r = eject_hole/2, h = ball_dia, $fn = 18 );
    slits( 0 );
    slits( 90 );
    slits( -90 );
    translate( [ height - slit_size - screw_head, 0, back_thickness ] ) screw();
    translate( [ slit_size + screw_head, 0, back_thickness ] ) screw();
  }
}
