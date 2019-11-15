* LM833
*****************************************************************************
* (C) Copyright 2016 Texas Instruments Incorporated. All rights reserved.
*****************************************************************************
** This model is designed as an aid for customers of Texas Instruments.
** TI and its licensors and suppliers make no warranties, either expressed
** or implied, with respect to this model, including the warranties of 
** merchantability or fitness for a particular purpose.  The model is
** provided solely on an "as is" basis.  The entire risk as to its quality
** and performance is with the customer.
*****************************************************************************
*
** Released by: WEBENCH(R) Design Center, Texas Instruments Inc.
* Part: LM833
* Date: 04/18/2016 14:35:06
* Model Type: All In One
* Simulator: TINA 
* Simulator Version: 9.3.80.273 SF
* EVM Order Number: AN-346 
* EVM Users Guide: SNOA586D, 07 May 2013
* Datasheet: SLOS481B, 22 Oct 2014
*
* Model Version: 1.0
*
*****************************************************************************
*
* Updates:
*
* Version 1.0 : Release to Web
*
*****************************************************************************
* Notes:
* 1. The following parameters are modeled:
*    Aol,GBW,PM,SR,Vos,Ibias,Ioffset,IbiasP,IbiasN,Vin-cm,CMRR,PSRR,
*    Voltage Noise,Current Noise,Zin_diff,Rout_OL,Rout_CL,Voh,Vol,
*    Iq/channel,Isc(I_source),Isc(I_sink) 
* 2. The following parameters are not modeled:
*    THD, Recovery time
*****************************************************************************

.subckt LM833 OUT IN- IN+ VCC- VCC+
XI0 VCC- VCC+ IN- IN+ OUT PD DALLASAMP_HT4
VPD VCC+ PD
.ends LM833

.subckt ANALOG_BUFFER VOUT VIN
R0 VIN 0 1e9
R1 VOUT 0 1e9
E0 VOUT 0 VIN 0 1
.ends ANALOG_BUFFER

.subckt DALLASAMP_DOMPOLE_HT4 A B
R0 B A 1.238e06
C0 A B 1.43e-09
.ends DALLASAMP_DOMPOLE_HT4

.subckt DALLASAMP_NONDOMPOLE_HT4 VIN VOUT
XI23 NET4 VIN ANALOG_BUFFER
C1 VOUT 0 8.503e-09
R1 VOUT NET4 1
.ends DALLASAMP_NONDOMPOLE_HT4

.subckt DALLASAMP_RECOVERYCIRCUIT_HT4 A B VCC VEE
XI2 NET8 NET014 DallasAmp_DiodeIdeal_HT4
XI3 NET014 NET9 DallasAmp_DiodeIdeal_HT4
VBRIDGE NET014 A 0
VPROBE A B 0
VRECL NET9 VEE -10e-3
VRECH VCC NET8 -10e-3
.ends DALLASAMP_RECOVERYCIRCUIT_HT4

.subckt DALLASAMP_OUTPUTCIR_HT4 PD VCC VCCMAIN VEE VEEMAIN VIN VOUT
XI21 NET75 NET76 VCC VEE DallasAmp_OutputCir_IsourceVlimit_HT4
XI20 NET79 NET092 VCC VEE DallasAmp_OutputCir_IsinkVlimit_HT4
XI17 VOL VEE VIMONINV DallasAmp_OutputCir_VOL_HT4
XI16 VCC VOH VIMON DallasAmp_OutputCir_VOH_HT4
DISOURCE NET092 NET75 OutputCir_Isc_DIDEAL
DISINK NET76 NET79 OutputCir_Isc_DIDEAL
*XI2500 NET75 NET092 OutputCir_IscDiodeIdeal PARAMS: IS=10e-15 N=50e-3
*XI2300 NET79 NET76 OutputCir_IscDiodeIdeal PARAMS: IS=10e-15 N=50e-3
XI14 NET070 NET15 DallasAmp_DiodeIdeal_HT4
XI15 NET068 VOL DallasAmp_DiodeIdeal_HT4
XI0 VCCMAIN VEEMAIN VIMON PD DallasAmp_OutputCir_ILOAD_HT4
XI1 NET53 NET22 VIMON DallasAmp_OutputCir_Rout_HT4
XI6 NET22 NET0100 0 NET043 VCC VEE RECOVERYSIGNAL DallasAmp_OutputCir_RecoveryAssist_HT4
XAHDLI43 NET055 NET054 RECOVERYSIGNAL VCC VEE HPA_OR2
XAHDLI41 VOUT NET067 NET055 VCC VEE HPA_COMP_IDEAL
XAHDLI42 NET059 VOUT NET054 VCC VEE HPA_COMP_IDEAL
HVIMONINV VIMONINV 0 VCURSINKDETECT  1
HVIMON VIMON 0 VCURSOURCEDETECT  1
RVIMONINV VIMONINV 0 1e9
RVIMON VIMON 0 1e9
RISC NET092 NET15 100e-3
ROUTMINOR NET0100 NET17 10
XI11 NET76 NET15 ANALOG_BUFFER
XI2 NET22 VIN ANALOG_BUFFER
VPROBE3 NET070 VOH 0
VPROBE2 NET043 NET0100 0
VTRIGGERVOL NET059 VOL 10e-3
VTRIGGERVOH VOH NET067 10e-3
VPROBE4 NET068 NET15 0
VCURSOURCEDETECT NET15 NET34 0
VCURSINKDETECT VOUT NET34 0
VPROBE1 NET53 NET17 0
LOUT NET17 NET092 500e-12
CP NET17 0 10e-15
COUT NET22 NET0100 1e-15
.ends DALLASAMP_OUTPUTCIR_HT4

.SUBCKT OutputCir_IscDiodeIdeal NEG POS PARAMS: 
+ IS = 1E-14
+ N  = 50m

G1 POS NEG_INT VALUE = { IF ( V(POS,NEG_INT) <= 0, IS, IS * ( EXP ( V(POS,NEG_INT)/25m
+ * 1/N)-0 ))}
V1 NEG_INT NEG {-N*0.8}
.ENDS

.subckt DALLASAMP_VINRANGE_HT4 VCC VEE VIN VOUT
XIDVIH NET12 NET16 DallasAmp_DiodeIdeal_HT4
XIDVIL NET16 NET20 DallasAmp_DiodeIdeal_HT4
R0 VIN NET16 1e-3
V0 NET16 VOUT 0
VIL NET20 VEE 1
VIH VCC NET12 1
.ends DALLASAMP_VINRANGE_HT4

.subckt DALLASAMP_ZIN_HT4 IN1 IN2 OUT1 OUT2
R4 IN1 OUT1 100e-3
R5 IN2 OUT2 100e-3
C1 OUT1 0 10e-12
C2 OUT2 0 10e-12
C3 OUT1 OUT2 7e-12
GR1 0 OUT1 0 OUT1 5.56e-08
GR2 OUT2 0 OUT2 0 5.56e-08
GR3 OUT1 OUT2 OUT1 OUT2 5.69e-06
.ends DALLASAMP_ZIN_HT4

.subckt DALLASAMP_HT4 VEE VCC VINM VINP VOUT PD
XI13 VEE_INT VEE ANALOG_BUFFER
XI12 VCC_INT VCC ANALOG_BUFFER
XI58 HIGHZ NET32 DALLASAMP_DOMPOLE_HT4
XI28 NET41 NET51 VCC_INT VEE_INT DALLASAMP_RECOVERYCIRCUIT_HT4
XI26 NET51 NET61 DALLASAMP_NONDOMPOLE_HT4
XI30 POWER VCC_INT VCC VEE_INT VEE NET61 VOUT DALLASAMP_OUTPUTCIR_HT4
IBIASP VINP_INT 0 3.125e-7
IBIASM VINM_INT 0 2.875e-7
XI56 VCC_INT VEE_INT NET22 VINM_INT DALLASAMP_VINRANGE_HT4
XI54 VCC_INT VEE_INT NET21 VINP_INT DALLASAMP_VINRANGE_HT4
XI53 VINP VINM NET1 NET2 DALLASAMP_ZIN_HT4
XI40 VCC VEE POWER VEE_INT VCC_INT DallasAmp_Iq_HT4
XI52 VINP_INT VINM_INT NET32 NET31 VEE_INT VCC_INT POWER DallasAmp_GmItail_HT4
XAHDLINV3 PD PDINV VCC_INT VEE_INT HPA_INV_IDEAL
XAHDLINV1 PDINV POWER VCC_INT VEE_INT HPA_INV_IDEAL
XI21 NET12 NET22 NET12 DallasAmp_CMRR_HT4
XI19 VCC_INT VEE_INT NET2 NET12 DallasAmp_PSRR_HT4
XI18 NET11 NET2 DallasAmp_Inoise_HT4
XI17 NET1 NET11 DallasAmp_Vnoise_HT4
R14 VCC_INT PD 10e6
VINOFFSET NET21 NET11 150e-6
*XVINOFFSET NET21 NET11 Vinoffset PARAMS: TA=25 VOS=0.15e-03 DRIFT=2e-6
VPROBE1 NET31 HIGHZ
VDOMPOLEBIAS NET32 0 0
VPROBE2 HIGHZ NET41
.ends DALLASAMP_HT4

.SUBCKT Vinoffset POS NEG PARAMS: 
+ TA     = 25
+ VOS    = 500u
+ DRIFT  = 10u 

E1 POS NEG VALUE = { DRIFT * TEMP + ( VOS - DRIFT * TA ) }
.ENDS

.SUBCKT HPA_OR2 1 2 3 VDD VSS
E1 4 0 VALUE = { IF( ((V(1)< (V(VDD)+V(VSS))/2 ) & (V(2)< (V(VDD)+V(VSS))/2 )), V(VSS), V(VDD) )}
R1 4 3 1
C1 3 0 1e-12
.ENDS

.SUBCKT HPA_INV_IDEAL 1 2 VDD VSS
E1 2 0 VALUE = { IF( V(1)> (V(VDD)+V(VSS))/2, V(VSS), V(VDD) ) }
.ENDS

.SUBCKT HPA_COMP_IDEAL INP INN OUT VDD VSS
E1 OUT 0 VALUE = { IF( (V(INP) > V(INN)), V(VDD), V(VSS) ) }
.ENDS

.SUBCKT DallasAmp_CMRR_HT4 A B C
.PARAM CMRR_DC 	             = -100
.PARAM CMRR_f3dB             = 5e3
.PARAM CMRR_f3dB_FudgeFactor = 1

.PARAM CMRR       = {0-CMRR_DC}
.PARAM FCMRR	  = {CMRR_f3dB * CMRR_f3dB_FudgeFactor}

X1 A B C 0 CMRR_NEW PARAMS: CMRR = {CMRR} FCMRR = {FCMRR}
.ENDS

.SUBCKT DallasAmp_DiodeIdeal_HT4 NEG POS
G1 POS NEG VALUE = { IF ( V(POS,NEG) <= 0 , 0, V(POS,NEG)*0.01G ) }
R0 POS NEG 1000G
.ENDS

.SUBCKT DallasAmp_GmItail_HT4  Vinp Vinm Ioutp Ioutm VEE VCC PD
X1 PD PDINV VCC VEE LOGIC1 0 DLSINV
VLOGIC1 LOGIC1 0 1

.PARAM ITAILMAX_X1 = { 5.0 }
.PARAM ITAILMAX_Y1 = { 10m }

.PARAM ITAILMAX_X2 = { 15.0 }
.PARAM ITAILMAX_Y2 = { 10m }

.PARAM ITAILMAX_SLOPE = 
+ { ( ITAILMAX_Y2 - ITAILMAX_Y1 ) / ( ITAILMAX_X2 - ITAILMAX_X1 ) }
.PARAM ITAILMAX_INTCP = 
+ { ITAILMAX_Y1 - ITAILMAX_SLOPE * ITAILMAX_X1 }

EITAILMAX ITAILMAX 0 VALUE = 
+ { ITAILMAX_SLOPE * V(VCC,VEE) + ITAILMAX_INTCP  }

.PARAM ITAILMIN_X1 = { 5.0 }
.PARAM ITAILMIN_Y1 = { 10m }

.PARAM ITAILMIN_X2 = { 15.0 }
.PARAM ITAILMIN_Y2 = { 10m }

.PARAM ITAILMIN_SLOPE = 
+ { ( ITAILMIN_Y2 - ITAILMIN_Y1 ) / ( ITAILMIN_X2 - ITAILMIN_X1 ) }
.PARAM ITAILMIN_INTCP = 
+ { ITAILMIN_Y1 - ITAILMIN_SLOPE * ITAILMIN_X1 }

EITAILMIN ITAILMIN 0 VALUE = 
+ { ITAILMIN_SLOPE * V(VCC,VEE) + ITAILMIN_INTCP  }

G1 IOUTP IOUTM VALUE = { LIMIT ( 1.436e-01 * V(VINP,VINM) * ( 1-V(PDINV) ) , -V(ITAILMIN),
+ V(ITAILMAX) ) }
.ENDS

.SUBCKT DallasAmp_Vnoise_HT4 A B
.PARAM X = { 10  }
.PARAM Y = { 9 }
.PARAM Z = { 4.5  }
X1 A B VNSE PARAMS: NLF = { Y } FLW = { X }  NVR = { Z }
.ENDS

.SUBCKT DallasAmp_Inoise_HT4 A B
.PARAM X = { 10  }
.PARAM Y = { 0.88e3 }
.PARAM Z = { 0.5e3 }
X1 A B FEMT PARAMS: NLFF = { Y }  FLWF = { X } NVRF = { Z }
.ENDS

.subckt DallasAmp_Iq_HT4 VCCmain VEEmain PD VEE VCC
.PARAM IOFF = { 1n }

.PARAM ION_X1 = { 0.0 }
.PARAM ION_Y1 = { 2.05m }

.PARAM ION_X2 = { 5 }
.PARAM ION_Y2 = { 2.05m }

.PARAM ION_X3 = { 12 }
.PARAM ION_Y3 = { 2.05m }

.PARAM ION_X4 = { 15 }
.PARAM ION_Y4 = { 2.05m }

EION_SEG1 ION_SEG1 0 VALUE = { IF ( 		          V(VCC,VEE) <= ION_X2, 1, 0 ) }
EION_SEG2 ION_SEG2 0 VALUE = { IF ( V(VCC,VEE) > ION_X2 & V(VCC,VEE) <= ION_X3, 1, 0 ) }
EION_SEG3 ION_SEG3 0 VALUE = { IF ( V(VCC,VEE) > ION_X3		              , 1, 0 ) }

.PARAM ION_SEG1_SLOPE = { ( ION_Y2 - ION_Y1 ) / ( ION_X2 - ION_X1 ) }
.PARAM ION_SEG1_INTCP = { ION_Y1 - ION_SEG1_SLOPE * ION_X1 }

.PARAM ION_SEG2_SLOPE = { ( ION_Y3 - ION_Y2 ) / ( ION_X3 - ION_X2 ) }
.PARAM ION_SEG2_INTCP = { ION_Y2 - ION_SEG2_SLOPE * ION_X2 }

.PARAM ION_SEG3_SLOPE = { ( ION_Y4 - ION_Y3 ) / ( ION_X4 - ION_X3 ) }
.PARAM ION_SEG3_INTCP = { ION_Y3 - ION_SEG3_SLOPE * ION_X3 }

EION ION 0 VALUE = { 	V(ION_SEG1) * ( ION_SEG1_SLOPE * V(VCC,VEE) + ION_SEG1_INTCP ) +
+			V(ION_SEG2) * ( ION_SEG2_SLOPE * V(VCC,VEE) + ION_SEG2_INTCP ) +
+ 			V(ION_SEG3) * ( ION_SEG3_SLOPE * V(VCC,VEE) + ION_SEG3_INTCP ) 	}

X1 PD PDINV VCC VEE LOGIC1 0 DLSINV
VLOGIC1 LOGIC1 0 1
G1 VCCMAIN VEEMAIN VALUE = { V(ION) * ( 1-V(PDINV) ) + IOFF * V(PDINV) }  
.ends

.SUBCKT DallasAmp_OutputCir_ILOAD_HT4  VDD VSS VIMON PD
X1 PD PDINV VDD VSS LOGIC1 0 DLSINV
VLOGIC1 LOGIC1 0 1
G1 VDD 0 VALUE = {IF(V(VIMON) >= 0, V(VIMON)*( 1-V(PDINV) ), 0)}
G2 VSS 0 VALUE = {IF(V(VIMON)  < 0, V(VIMON)*( 1-V(PDINV) ), 0)}
.ENDS

.SUBCKT DallasAmp_OutputCir_IscDiodeIdeal_HT4 NEG POS
G1 POS NEG VALUE = { IF ( V(POS,NEG) <= 0 , 0, V(POS,NEG)*0.01G ) }
R0 POS NEG 1000G
.ENDS

.SUBCKT DallasAmp_OutputCir_IscVlimit_HT4 A B VCC VEE PARAMS:
+RIsc 		 = { 100m }

+IscVsVsupply_X1 = { 3.0 }
+IscVsVsupply_Y1 = { 75m }

+IscVsVsupply_X2 = { 5.0 }
+IscVsVsupply_Y2 = { 100m }

.PARAM IscVsVsupply_SLOPE = 
+ { ( IscVsVsupply_Y2 - IscVsVsupply_Y1 ) / ( IscVsVsupply_X2 - IscVsVsupply_X1 ) }
.PARAM IscVsVsupply_INTCP = 
+ { IscVsVsupply_Y1 - IscVsVsupply_SLOPE * IscVsVsupply_X1 }

EIscVsVsupply IscVsVsupply 0 VALUE = 
+ { IscVsVsupply_SLOPE * V(VCC,VEE) + IscVsVsupply_INTCP  }

E1 A B VALUE = { V(IscVsVsupply) * RIsc }
.ENDS

.SUBCKT DallasAmp_OutputCir_IsinkVlimit_HT4 A B VCC VEE

X1 A B VCC VEE DallasAmp_OutputCir_IscVlimit_HT4 PARAMS:
+RIsc 		 = { 100m }

+IscVsVsupply_X1 = { 5.0 }
+IscVsVsupply_Y1 = { ABS(-37m) }

+IscVsVsupply_X2 = { 15.0 }
+IscVsVsupply_Y2 = { ABS(-37m) }

.ENDS

.SUBCKT DallasAmp_OutputCir_IsourceVlimit_HT4 A B VCC VEE

X1 A B VCC VEE DallasAmp_OutputCir_IscVlimit_HT4 PARAMS:
+RIsc 		 = { 100m }

+IscVsVsupply_X1 = { 5.0 }
+IscVsVsupply_Y1 = { ABS(29m) }

+IscVsVsupply_X2 = { 15.0 }
+IscVsVsupply_Y2 = { ABS(29m) }

.ENDS

.SUBCKT DallasAmp_OutputCir_RecoveryAssist_HT4  VINP VINM IOUTP IOUTM VCC VEE RecoverySignal
X1 RecoverySignal RS VCC VEE LOGIC1 0 DLS
VLOGIC1 LOGIC1 0 1
G1 IOUTP IOUTM VALUE = { LIMIT ( 1m * V(VINP,VINM) *  V(RS) , -100m, 100m ) }
.ENDS

.SUBCKT DallasAmp_OutputCir_Rout_HT4 B A VIMON
.PARAM Ro_Iout_0A = 37
.PARAM RIsc = 100m
.PARAM Isc = 33m
** Isc = (Isc_source + I_sink)/2 
.PARAM Islope = { 1/100 * Isc }

G1 A B VALUE = { V(A,B) * 1 / ( (Ro_Iout_0A - RIsc) * Islope / ( Islope + ABS(V(VIMON)) ))}
.ENDS

.SUBCKT DallasAmp_OutputCir_VOHVOLDiodeIdeal_HT4 NEG POS
G1 POS NEG VALUE = { IF ( V(POS,NEG) <= 0 , 0, V(POS,NEG)*0.01G ) }
R0 POS NEG 1000G
.ENDS

.SUBCKT DallasAmp_OutputCir_VOHVOL_HT4 A B C  PARAMS:
+ VSUPPLYREF    = {2.5} 
+ VOUTvsIOUT_X1 = { 0 }
+ VOUTvsIOUT_Y1 = { 2.4 }

+ VOUTvsIOUT_X2 = { 100m }
+ VOUTvsIOUT_Y2 = { 2.1 }

.PARAM VDROPvsIOUT_X1 = { VOUTvsIOUT_X1 }
.PARAM VDROPvsIOUT_Y1 = { ABS(VSUPPLYREF-VOUTvsIOUT_Y1) }

.PARAM VDROPvsIOUT_X2 = { VOUTvsIOUT_X2 }
.PARAM VDROPvsIOUT_Y2 = { ABS(VSUPPLYREF-VOUTvsIOUT_Y2) }

.PARAM VDROPvsIOUT_SLOPE = 
+ { ( VDROPvsIOUT_Y2 - VDROPvsIOUT_Y1 ) / ( VDROPvsIOUT_X2 - VDROPvsIOUT_X1 ) }
.PARAM VDROPvsIOUT_INTCP = 
+ { VDROPvsIOUT_Y1 - VDROPvsIOUT_SLOPE * VDROPvsIOUT_X1 }

EVDROPvsIOUT VDROPvsIOUT 0 VALUE = 
+ { VDROPvsIOUT_SLOPE * V(C) + VDROPvsIOUT_INTCP  }
E1 A B VALUE = { V(VDROPvsIOUT) }
.ENDS

.SUBCKT DallasAmp_OutputCir_VOH_HT4 A B C 
X1 A B C DallasAmp_OutputCir_VOHVOL_HT4 PARAMS:
+ VSUPPLYREF    = {15}

+ VOUTvsIOUT_X1 = { ABS(0.8m) }
+ VOUTvsIOUT_Y1 = { 14.17 }
*+ VOUTvsIOUT_X1 = { ABS(0) }
*+ VOUTvsIOUT_Y1 = { 14.1 }

+ VOUTvsIOUT_X2 = { ABS(15.82m) }
+ VOUTvsIOUT_Y2 = { 13.5 }
.ENDS

.SUBCKT DallasAmp_OutputCir_VOL_HT4 A B C
X1 A B C DallasAmp_OutputCir_VOHVOL_HT4 PARAMS:
+ VSUPPLYREF    = {-15}

+ VOUTvsIOUT_X1 = { ABS(0.9m) }
+ VOUTvsIOUT_Y1 = { -14.8 }
*+ VOUTvsIOUT_X1 = { ABS(0) }
*+ VOUTvsIOUT_Y1 = { -14.6 }

+ VOUTvsIOUT_X2 = { ABS(-13.1m) }
+ VOUTvsIOUT_Y2 = { -13.1 }
.ENDS

.SUBCKT DallasAmp_PSRR_HT4 VDD VSS A B

.PARAM PSRRP_DC    = -105
.PARAM PSRRP_f3dB  = 90k

.PARAM PSRRN_DC    = -105
.PARAM PSRRN_f3dB  = 90k

.PARAM PSRRP       = {0-PSRRP_DC}
.PARAM PSRRN       = {0-PSRRN_DC}
.PARAM FPSRRP      = {PSRRP_f3dB}
.PARAM FPSRRN      = {PSRRN_f3dB}

X1 VDD VSS A B 0 PSRR_DUAL_NEW PARAMS:
+ PSRRP = {PSRRP} FPSRRP = {FPSRRP}
+ PSRRN = {PSRRN} FPSRRN = {FPSRRN}
.ENDS

.SUBCKT DallasAmp_RecoveryCircuit_DiodeIdeal_HT4 NEG POS
G1 POS NEG VALUE = { IF ( V(POS,NEG) <= 0 , 0, V(POS,NEG)*0.01G ) }
R0 POS NEG 1000G
.ENDS

.SUBCKT DallasAmp_Vinrange_DiodeIdeal_HT4 NEG POS
G1 POS NEG VALUE = { IF ( V(POS,NEG) <= 0 , 0, V(POS,NEG)*0.01G ) }
R0 POS NEG 1000G
.ENDS

.SUBCKT VNSE  1 2 PARAMS: NLF = 10 FLW = 4  NVR = 4.6
.PARAM GLF={PWR(FLW,0.25)*NLF/1164}
.PARAM RNV={1.184*PWR(NVR,2)}
.MODEL DVN D KF={PWR(FLW,0.5)/1E11} IS=1.0E-16
I1 0 7 10E-3
I2 0 8 10E-3
D1 7 0 DVN
D2 8 0 DVN
E1 3 6 7 8 {GLF}
R1 3 0 1E9
R2 3 0 1E9
R3 3 6 1E9
E2 6 4 5 0 10
R4 5 0 {RNV}
R5 5 0 {RNV}
R6 3 4 1E9
R7 4 0 1E9
E3 1 2 3 4 1
C1 1 0 1E-15
C2 2 0 1E-15
C3 1 2 1E-15
.ENDS

.SUBCKT FEMT  1 2 PARAMS: NLFF = 0.1 FLWF = 0.001 NVRF = 0.1
.PARAM GLFF={PWR(FLWF,0.25)*NLFF/1164}
.PARAM RNVF={1.184*PWR(NVRF,2)}
.MODEL DVNF D KF={PWR(FLWF,0.5)/1E11} IS=1.0E-16
I1 0 7 10E-3
I2 0 8 10E-3
D1 7 0 DVNF
D2 8 0 DVNF
E1 3 6 7 8 {GLFF}
R1 3 0 1E9
R2 3 0 1E9
R3 3 6 1E9
E2 6 4 5 0 10
R4 5 0 {RNVF}
R5 5 0 {RNVF}
R6 3 4 1E9
R7 4 0 1E9
G1 1 2 3 4 1E-6
C1 1 0 1E-15
C2 2 0 1E-15
C3 1 2 1E-15
.ENDS

.SUBCKT PSRR_SINGLE   VDD  VSS  VI  VO  GNDF PARAMS: PSRR = 130 FPSRR = 1.6
.PARAM PI = 3.141592
.PARAM RPSRR = 1
.PARAM GPSRR = {PWR(10,-PSRR/20)/RPSRR}
.PARAM LPSRR = {RPSRR/(2*PI*FPSRR)}
G1  GNDF 1 VDD VSS {GPSRR}
R1  1 2 {RPSRR}
L1  2 GNDF {LPSRR}
E1  VO VI 1 GNDF 1
C2  VDD VSS 10P
.ENDS

.SUBCKT PSRR_SINGLE_NEW   VDD  VSS  VI  VO  GNDF PARAMS: PSRR = 130 FPSRR = 1.6
.PARAM PI = 3.141592
.PARAM RPSRR = 1
.PARAM GPSRR = {PWR(10,-PSRR/20)/RPSRR}
.PARAM LPSRR = {RPSRR/(2*PI*FPSRR)}
G1  GNDF 1 VDD VSS {GPSRR}
R1  1 2 {RPSRR}
L1  2 GNDF {LPSRR}

EA  101 GNDF 1 GNDF 1
GRA  101 102 VALUE = { V(101,102)/1e6 }
CA  102 GNDF 1e3
EB  1 1a VALUE = {V(102,GNDF)}

E1  VO VI 1a GNDF 1
C2  VDD VSS 10P
.ENDS

.SUBCKT PSRR_DUAL   VDD  VSS  VI  VO  GNDF 
+ PARAMS: PSRRP = 130 FPSRRP = 1.6
+ PSRRN = 130 FPSRRN = 1.6
.PARAM PI = 3.141592
.PARAM RPSRRP = 1
.PARAM GPSRRP = {PWR(10,-PSRRP/20)/RPSRRP}
.PARAM LPSRRP = {RPSRRP/(2*PI*FPSRRP)}
.PARAM RPSRRN = 1
.PARAM GPSRRN = {PWR(10,-PSRRN/20)/RPSRRN}
.PARAM LPSRRN = {RPSRRN/(2*PI*FPSRRN)}
G1  GNDF 1 VDD GNDF {GPSRRP}
R1  1 2 {RPSRRP}
L1  2 GNDF {LPSRRP}

G2  GNDF 3 VSS GNDF {GPSRRN}
R2  3 4 {RPSRRN}
L2  4 GNDF {LPSRRN}

E1  VO VI VALUE = {V(1,GNDF) + V(3,GNDF)}
C3  VDD VSS 10P
.ENDS

.SUBCKT PSRR_DUAL_NEW   VDD  VSS  VI  VO  GNDF 
+ PARAMS: PSRRP = 130 FPSRRP = 1.6
+ PSRRN = 130 FPSRRN = 1.6
.PARAM PI = 3.141592
.PARAM RPSRRP = 1
.PARAM GPSRRP = {PWR(10,-PSRRP/20)/RPSRRP}
.PARAM LPSRRP = {RPSRRP/(2*PI*FPSRRP)}
.PARAM RPSRRN = 1
.PARAM GPSRRN = {PWR(10,-PSRRN/20)/RPSRRN}
.PARAM LPSRRN = {RPSRRN/(2*PI*FPSRRN)}

G1  GNDF 1 VDD GNDF {GPSRRP}
R1  1 2 {RPSRRP}
L1  2 GNDF {LPSRRP}

EA  101 GNDF 1 GNDF 1
GRA  101 102 VALUE = { V(101,102)/1e6 }
CA  102 GNDF 1e3
EB  1 1a VALUE = {V(102,GNDF)}

G2  GNDF 3 VSS GNDF {GPSRRN}
R2  3 4 {RPSRRN}
L2  4 GNDF {LPSRRN}

EC  301 GNDF 3 GNDF 1
GRC  301 302 VALUE = { V(301,302)/1e6 }
CC  302 GNDF 1e3
ED  3 3a VALUE = {V(302,GNDF)}

E1  VO VI VALUE = {V(1a,GNDF) + V(3a,GNDF)}
C3  VDD VSS 10P
.ENDS

.SUBCKT CMRR   VI  VO  VX GNDF PARAMS: CMRR = 130 FCMRR = 1.6K
.PARAM PI = 3.141592
.PARAM RCMRR = 1
.PARAM GCMRR = {PWR(10,-CMRR/20)/RCMRR}
.PARAM LCMRR = {RCMRR/(2*PI*FCMRR)}
G1  GNDF 1 VX GNDF {GCMRR}
R1  1 2 {RCMRR}
L1  2 GNDF {LCMRR}
E1  VI VO 1 GNDF 1
.ENDS

.SUBCKT CMRR_NEW   VI  VO VX GNDF PARAMS: CMRR = 130 FCMRR = 1.6K
.PARAM PI = 3.141592
.PARAM RCMRR = 1
.PARAM GCMRR = {PWR(10,-CMRR/20)/RCMRR}
.PARAM LCMRR = {RCMRR/(2*PI*FCMRR)}
G1  GNDF 1 VX GNDF {GCMRR}
R1  1 2 {RCMRR}
L1  2 GNDF {LCMRR}

EA  101 GNDF 1 GNDF 1
GRA  101 102 VALUE = {V(101,102)/1e6}
CA  102 GNDF 1e3
EB  1 1a VALUE = {V(102,GNDF)}

E1  VI VO 1a GNDF 1
.ENDS

.SUBCKT DLS 1 2 VDD_OLD VSS_OLD VDD_NEW VSS_NEW
E1 3 0 VALUE = { IF( V(1) < (V(VDD_OLD)+V(VSS_OLD))/2, V(VSS_NEW), V(VDD_NEW) ) }
R1 3 2 1
C1 2 0 1p
.ENDS

.SUBCKT DLSINV 1 2 VDD_OLD VSS_OLD VDD_NEW VSS_NEW
E1 3 0 VALUE = { IF( V(1) > (V(VDD_OLD)+V(VSS_OLD))/2, V(VSS_NEW), V(VDD_NEW) ) }
R1 3 2 1
C1 2 0 1p
.ENDS

.MODEL VINRANGE_DIDEAL         D N=1m
.MODEL RECOVERYCIRCUIT_DIDEAL  D N=1m 
.MODEL OUTPUTCIR_ISC_DIDEAL    D N=0.1m 
.MODEL OUTPUTCIR_VOHVOL_DIDEAL D N=1m 