/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViImg 5.20.3 */

#ifndef _BRDKVIIMG_
#define _BRDKVIIMG_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViImg_VERSION
#define _brdkViImg_VERSION 5.20.3
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "FileIO.h"
		#include "AsHttp.h"
		#include "standard.h"
		#include "ViBase.h"
		#include "brdkViBase.h"
		#include "AsTCP.h"
#endif
#ifdef _SG4
		#include "FileIO.h"
		#include "AsHttp.h"
		#include "standard.h"
		#include "ViBase.h"
		#include "brdkViBase.h"
		#include "AsTCP.h"
#endif
#ifdef _SGC
		#include "FileIO.h"
		#include "AsHttp.h"
		#include "standard.h"
		#include "ViBase.h"
		#include "brdkViBase.h"
		#include "AsTCP.h"
#endif


/* Constants */
#ifdef _REPLACE_CONST
 #define BRDKVIS_BASE64_BUSY 64001U
 #define BRDKVIIMG_WS_BUFFER_SIZE 10000U
 #define BRDKVIIMG_WS_MAX_NUM_CLIENTS 10U
 #define ERR_NO_SIM_PFILE 64002U
 #define ERR_NO_IMAGE 64000U
#else
 _GLOBAL_CONST unsigned short BRDKVIS_BASE64_BUSY;
 _GLOBAL_CONST unsigned long BRDKVIIMG_WS_BUFFER_SIZE;
 _GLOBAL_CONST unsigned long BRDKVIIMG_WS_MAX_NUM_CLIENTS;
 _GLOBAL_CONST unsigned short ERR_NO_SIM_PFILE;
 _GLOBAL_CONST unsigned short ERR_NO_IMAGE;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum BRDKVIIMG_IMG_TYPE
{	BRDKVIIMG_IMG_TYPE_BMP,
	BRDKVIIMG_IMG_TYPE_JPEG
} BRDKVIIMG_IMG_TYPE;

typedef enum BRDKVIIMG_WSSER_STATES
{	BRDKVIIMG_WSSER_UNINIT,
	BRDKVIIMG_WSSER_OPENING,
	BRDKVIIMG_WSSER_LISTINING,
	BRDKVIIMG_WSSER_ACCEPT_RECV,
	BRDKVIIMG_WSSER_ACCEPT_SEND,
	BRDKVIIMG_WSSER_DENY,
	BRDKVIIMG_WSSER_CLOSING
} BRDKVIIMG_WSSER_STATES;

typedef enum BRDKVIIMG_WSCH_STATES
{	BRDKVIIMG_WSCH_INIT,
	BRDKVIIMG_WSCH_RECV,
	BRDKVIIMG_WSCH_SEND,
	BRDKVIIMG_WSCH_SENDING,
	BRDKVIIMG_WSCH_CLOSE,
	BRDKVIIMG_WSCH_CLOSED,
	BRDKVIIMG_WSCH_CLEANUP
} BRDKVIIMG_WSCH_STATES;

typedef struct brdkViImg_getImageSimulate_typ
{	unsigned long pFile;
	unsigned long pDevice;
	plcbit activate;
	plcbit autoIncrementNumber;
	plcbit useRandomNumbers;
	plcbit appendNumber;
	unsigned long maxNumber;
	unsigned long minNumber;
} brdkViImg_getImageSimulate_typ;

typedef struct brdkViImg_getImageMemInfo_typ
{	unsigned long uploadAdr;
	unsigned long uploadSize;
	unsigned long imageAdr;
	unsigned long imageSize;
} brdkViImg_getImageMemInfo_typ;

typedef struct brdkViImg_getImageInternal_typ
{	struct brdkViImg_getImageMemInfo_typ memInfo;
	struct FileClose fileClose_0;
	struct FileRead fileRead_0;
	struct FileOpen fileOpen_0;
	plcstring fileName[256];
	unsigned long fileNumber;
	struct ViBaseGetImage viBaseGetImage_0;
} brdkViImg_getImageInternal_typ;

typedef struct brdkViImg_getImage
{
	/* VAR_INPUT (analog) */
	unsigned long pMappLink;
	enum BRDKVIIMG_IMG_TYPE imageFormat;
	struct brdkViImg_getImageSimulate_typ simulateConfig;
	unsigned char jpegQuality;
	plctime timeout;
	/* VAR_OUTPUT (analog) */
	unsigned long pDest;
	unsigned long destLen;
	unsigned short status;
	/* VAR (analog) */
	unsigned char state;
	struct brdkViImg_getImageInternal_typ internal;
	plcstring tmpStr1[81];
	/* VAR_INPUT (digital) */
	plcbit getImage;
	plcbit enable;
	/* VAR_OUTPUT (digital) */
	plcbit initDone;
} brdkViImg_getImage_typ;

typedef struct brdkVIImg_imageArray_typ
{	unsigned long pData;
	unsigned long colors;
	unsigned long height;
	unsigned long width;
	unsigned long size;
} brdkVIImg_imageArray_typ;

typedef struct brdkViImg_WsServerInternal_typ
{	struct TcpOpen tcpOpen;
	struct TcpServer tcpServer;
	struct TcpIoctl tcpIoctl;
	struct TcpRecv tcpRecieve;
	struct TcpSend tcpSend;
	struct TcpClose tcpClose;
	unsigned char* receiveBuffer;
	unsigned char* sendBuffer;
	enum BRDKVIIMG_WSSER_STATES state;
	unsigned char clientNum;
	unsigned char sendMsgState;
	unsigned char clientCount;
	unsigned long server;
	plcstring clientIp[25];
	unsigned char closeCount;
	unsigned char sendMsgClient;
	plcbit sending;
	unsigned char nextMsgState;
	unsigned long tmppMsg;
	unsigned long tmpMsgLength;
	unsigned char maxNumberOfClients;
	unsigned long newClientId;
	plcbit newClient;
	unsigned char* recvBuffer;
} brdkViImg_WsServerInternal_typ;

typedef struct brdkViImg_WsServer
{
	/* VAR_INPUT (analog) */
	unsigned short port;
	unsigned long pIfAddr;
	unsigned long bufferSize;
	/* VAR_OUTPUT (analog) */
	plcstring clientIps[11][25];
	unsigned long clients[11];
	unsigned short statusMsg;
	unsigned short status;
	unsigned short numberOfConnectedClients;
	/* VAR (analog) */
	struct brdkViImg_WsServerInternal_typ internal;
	/* VAR_INPUT (digital) */
	plcbit enable;
} brdkViImg_WsServer_typ;

typedef struct brdkViImg_WsChannel
{
	/* VAR_INPUT (analog) */
	unsigned long ident;
	unsigned long bufferSize;
	unsigned long pSendData;
	unsigned long sendLen;
	unsigned long pRecvData;
	unsigned long parentServer;
	/* VAR_OUTPUT (analog) */
	unsigned short rcvLen;
	unsigned char rcvFrameType;
	unsigned short recvStatus;
	unsigned short sendStatus;
	/* VAR (analog) */
	struct TcpRecv receiver;
	struct TcpSend sender;
	struct TcpClose closer;
	unsigned long nextFrameOffset;
	unsigned char* recvBuffer;
	unsigned char* sendBuffer;
	enum BRDKVIIMG_WSCH_STATES state;
	unsigned char closeCount;
	/* VAR_INPUT (digital) */
	plcbit enable;
	plcbit doSend;
	/* VAR (digital) */
	plcbit closeRequest;
} brdkViImg_WsChannel_typ;

typedef struct brdkViImg_mappViewInternal_typ
{	struct TON heartbeat_ton;
	unsigned long taskIdent;
	plcstring name[11];
	unsigned long tick;
	unsigned char state;
	struct brdkViImg_getImage getImage;
	struct brdkVIImg_imageArray_typ tmpImgArr;
	plcstring strImgEnd[101];
	unsigned long startAdrBase64;
	plcbit init;
	unsigned long imgH;
	unsigned long imgW;
	unsigned long oldPSvgImage;
	unsigned long maxLength;
	unsigned long svgBaseLength;
	plcbit newSvgReady;
	struct brdkViImg_WsServer wsServer;
	unsigned long svgMaxLength;
	unsigned long pSvg;
	unsigned long pTmpMsg;
	unsigned long pTmpMem;
	unsigned long tmpMsgSize;
	unsigned long tmpMemSize;
	struct brdkViImg_WsChannel wsChannels[11];
	unsigned long actualMsgLength;
	plcbit wsSend;
	unsigned char wsRecData[11][200];
} brdkViImg_mappViewInternal_typ;

typedef struct brdkViImg_WsChannelInternal_typ
{	struct TcpRecv receiver;
	struct TcpSend sender;
	struct TcpClose closer;
	unsigned long nextFrameOffset;
	unsigned char* sendBuffer;
	enum BRDKVIIMG_WSCH_STATES state;
	plcbit closeRequest;
	unsigned char closeCount;
} brdkViImg_WsChannelInternal_typ;

typedef struct brdkViImg_mappViewInfo_typ
{	unsigned long heartbeat;
	unsigned long failedCount;
	unsigned long imgCount;
} brdkViImg_mappViewInfo_typ;

typedef struct brdkViImg_bmpInfoHeader_typ
{	unsigned long size;
	signed long width;
	signed long height;
	unsigned short planes;
	unsigned short bit_count;
	unsigned long compression;
	unsigned long size_image;
	signed long x_pixels_per_meter;
	signed long y_pixels_per_meter;
	unsigned long colors_used;
	unsigned long colors_imported;
} brdkViImg_bmpInfoHeader_typ;

typedef struct brdkViImg_bmpFileHeader_typ
{	unsigned short file_type;
	unsigned long file_size;
	unsigned short reserved1;
	unsigned short reserved2;
	unsigned long offset_data;
} brdkViImg_bmpFileHeader_typ;

typedef struct brdkViImg_bmpColorHeader_typ
{	unsigned long red_mask;
	unsigned long green_mask;
	unsigned long blue_mask;
	unsigned long alpha_mask;
	unsigned long color_space_type;
	unsigned long unused[16];
} brdkViImg_bmpColorHeader_typ;

typedef struct brdkViImg_bmpHeader_typ
{	struct brdkViImg_bmpFileHeader_typ file_header;
	struct brdkViImg_bmpInfoHeader_typ bmp_info;
	struct brdkViImg_bmpColorHeader_typ bmp_color;
} brdkViImg_bmpHeader_typ;

typedef struct brdkViImg_mappView
{
	/* VAR_INPUT (analog) */
	struct brdkViImg_getImageSimulate_typ simulateConfig;
	enum BRDKVIIMG_IMG_TYPE imageFormat;
	unsigned char jpegQuality;
	unsigned long pMappLink;
	unsigned long pSvgImage;
	unsigned long maxSvgImageLength;
	struct brdkViBase_2d_typ svgImagePosition;
	struct brdkVIImg_imageArray_typ* pImageArray;
	unsigned short wsPort;
	unsigned long timeout;
	/* VAR_OUTPUT (analog) */
	unsigned long status;
	struct brdkViImg_mappViewInfo_typ info;
	unsigned long svgLength;
	/* VAR (analog) */
	struct brdkViImg_mappViewInternal_typ internal;
	/* VAR_INPUT (digital) */
	plcbit enable;
	plcbit updateImage;
	plcbit getImageArray;
	/* VAR_OUTPUT (digital) */
	plcbit newSvgReady;
} brdkViImg_mappView_typ;

typedef struct brdkViImg_JpgDecode
{
	/* VAR_INPUT (analog) */
	unsigned char* pSrc;
	unsigned long len;
	unsigned long sizeMem;
	plcstring name[33];
	/* VAR_OUTPUT (analog) */
	signed short width;
	signed short height;
	signed short channels;
	unsigned long pDest;
	unsigned long status;
	unsigned long failedCnt;
	unsigned long imgCnt;
	/* VAR (analog) */
	unsigned long taskIdent;
	unsigned char state;
	unsigned char tick;
	unsigned char tickOld;
	struct TON tonHeartbeat;
	/* VAR_INPUT (digital) */
	plcbit enable;
	plcbit start;
} brdkViImg_JpgDecode_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void brdkViImg_getImage(struct brdkViImg_getImage* inst);
_BUR_PUBLIC void brdkViImg_mappView(struct brdkViImg_mappView* inst);
_BUR_PUBLIC void brdkViImg_JpgDecode(struct brdkViImg_JpgDecode* inst);
_BUR_PUBLIC void brdkViImg_WsServer(struct brdkViImg_WsServer* inst);
_BUR_PUBLIC void brdkViImg_WsChannel(struct brdkViImg_WsChannel* inst);
_BUR_PUBLIC unsigned long brdkViImg_freeMem(unsigned long pointer);
_BUR_PUBLIC unsigned char brdkViImg_getPixel(signed short x, signed short y, unsigned long width, unsigned char* pSrc);
_BUR_PUBLIC unsigned long brdkViImg_JpgEncode(unsigned long pSrc, unsigned long len, signed short width, signed short height, signed short channels, unsigned char quality, unsigned char* pDest);
_BUR_PUBLIC plcbit brdkViImg_getBmpImgInfo(unsigned long pSrc, unsigned long len, struct brdkVIImg_imageArray_typ* pDest);
_BUR_PUBLIC plcbit brdkViImg_getJpegImgInfo(unsigned long pSrc, unsigned long len, struct brdkVIImg_imageArray_typ* pDest);
_BUR_PUBLIC plcbit brdkViImg_base64Encode(unsigned char* pSrc, unsigned long len, unsigned char* pDest, unsigned long maxDestLen, unsigned long* pDestLen);
_BUR_PUBLIC plcbit brdkViImg_base64Decode(unsigned char* pSrc, unsigned long len, unsigned char* pDest, unsigned long maxDestLen, unsigned long* pDestLen);
_BUR_PUBLIC unsigned long brdkViImg_bmpDecode(unsigned long pSrc, unsigned long pDest, unsigned long* sizeMem, struct brdkViImg_bmpHeader_typ* bmpHeader, unsigned long* height, unsigned long* width, unsigned char* channels);
_BUR_PUBLIC plcbit brdkViImg_WsMakeFrame(signed char* data, unsigned long dataLength, signed char* outframe, unsigned long* outLenght, plcbit text);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVIIMG_ */

