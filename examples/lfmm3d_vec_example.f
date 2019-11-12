      implicit none
      integer ns,nt,nd
      double precision, allocatable :: source(:,:),targ(:,:)
      double precision, allocatable :: charge(:,:),dipvec(:,:,:)
      double precision, allocatable :: pot(:,:),grad(:,:,:)
      double precision, allocatable :: potex(:,:),gradex(:,:,:)
      double precision, allocatable :: pottarg(:,:),gradtarg(:,:,:)
      double precision, allocatable :: pottargex(:,:),gradtargex(:,:,:)

      double precision eps
      integer i,j,k,idim,ntest
      double precision hkrand,thresh,erra,ra
      


c
cc      initialize printing routine
c
      call prini(6,13)
      write(*,*)
      write(*,*)
      write(*,*) "================================="
      call prin2("This code is an example fortran driver*",i,0)
      call prin2("On output, the code prints sample pot,pottarg*",i,0)
      write(*,*)
      write(*,*)

      ns = 23
      nt = 27

      ntest = 10
      
      nd = 3

      allocate(source(3,ns))
      allocate(targ(3,nt))
      allocate(charge(nd,ns))
      allocate(dipvec(nd,3,ns))

      allocate(pot(nd,ns))
      allocate(potex(nd,ntest))

      allocate(grad(nd,3,ns))
      allocate(gradex(nd,3,ntest))
      
      
      allocate(pottarg(nd,nt))
      allocate(pottargex(nd,ntest))
      
      allocate(gradtarg(nd,3,nt))
      allocate(gradtargex(nd,3,ntest))

      thresh =1.0d-16

      eps = 0.5d-9

      write(*,*) "=========================================="

c
c   
c       example demonstrating use of 
c        source to source+targ, charges+dipoles, pot
c



c
cc      generate sources uniformly in the unit cube 
c
c
      do i=1,ns
        source(1,i) = hkrand(0)**2
        source(2,i) = hkrand(0)**2
        source(3,i) = hkrand(0)**2

        do idim=1,nd
          charge(idim,i) = hkrand(0) 
          dipvec(idim,1,i) = hkrand(0) 
          dipvec(idim,2,i) = hkrand(0) 
          dipvec(idim,3,i) = hkrand(0) 
          pot(idim,i) = 0
        enddo
      enddo

      do i=1,nt
        targ(1,i) = hkrand(0)**2
        targ(2,i) = hkrand(0)**2
        targ(3,i) = hkrand(0)**2

        do idim=1,nd
          pottarg(idim,i) = 0
          gradtarg(idim,1,i) = 0
          gradtarg(idim,2,i) = 0
          gradtarg(idim,3,i) = 0
        enddo
      enddo



       call lfmm3d_st_cd_g_vec(nd,eps,ns,source,charge,
     1      dipvec,pot,grad,nt,targ,pottarg,gradtarg)

       do i=1,ntest
         do idim=1,nd
           potex(idim,i) = 0
           gradex(idim,1,i) = 0
           gradex(idim,2,i) = 0
           gradex(idim,3,i) = 0

           pottargex(idim,i) = 0
           gradtargex(idim,1,i) = 0
           gradtargex(idim,2,i) = 0
           gradtargex(idim,3,i) = 0
         enddo

       enddo

       call l3ddirectcdg(nd,source,charge,
     1      dipvec,ns,source,ntest,potex,gradex,thresh)


       call l3ddirectcdg(nd,source,charge,
     1      dipvec,ns,targ,ntest,pottargex,gradtargex,thresh)

       call prin2("potential at sources=*",pot,6)
       call prin2("potential at sources=*",potex,6)


       erra = 0
       ra = 0
       do i=1,ntest
         do idim=1,nd
           ra = ra + potex(idim,i)**2
           erra = erra + (potex(idim,i)-pot(idim,i))**2
         enddo
       enddo

       erra = sqrt(erra/ra)
       call prin2("error pot src=*",erra,1)

      erra = 0
      ra = 0
      do i=1,ntest
        do j=1,3
          do idim=1,nd
            erra = erra + (gradex(idim,j,i)-grad(idim,j,i))**2
            ra = ra + (gradex(idim,j,i))**2
          enddo
        enddo
      enddo

      erra = sqrt(erra/ra)

      call prin2('error grad src=*',erra,1)



       erra = 0
       ra = 0
       do i=1,ntest
         do idim=1,nd
           ra = ra + pottargex(idim,i)**2
           erra = erra + (pottargex(idim,i)-pottarg(idim,i))**2
         enddo
       enddo

       erra = sqrt(erra/ra)
       call prin2("error pot targ=*",erra,1)

      erra = 0
      ra = 0
      do i=1,ntest
        do j=1,3
          do idim=1,nd
            erra = erra + (gradtargex(idim,j,i)-gradtarg(idim,j,i))**2
            ra = ra + (gradtargex(idim,j,i))**2
          enddo
        enddo
      enddo

      erra = sqrt(erra/ra)

      call prin2('error grad targ=*',erra,1)




      stop
      end
c----------------------------------------------------------
c
cc
c
c
