
// ForCHDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "ForCH.h"
#include "ForCHDlg.h"
#include "afxdialogex.h"
#include <string>
#include <vector>
#include<cv.h>
#include<cxcore.h>
#include<highgui.h>
#include "..\Common\C_Folder.h"
#include "..\Common\C_Mat2File.h"
#include "..\Common\C_Text.h"
#include "..\Common\C_Measure.h"
#include "..\Common\C_Picture.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

using namespace std;
using namespace cv;

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

	// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CForCHDlg 对话框




CForCHDlg::CForCHDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CForCHDlg::IDD, pParent)
	, m_folderPath(_T("D:\\Audi\\ori_frontal\\ori_img\\BU4D"))
	, m_fileFilter(_T(".jpg"))
	, m_dstFolderPath(_T("D:\\Audi\\ori_frontal\\ori_img\\BU4D_250"))
	, m_IDFrom(_T(""))
	, m_IDTo(_T(""))
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CForCHDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT1, m_folderPath);
	DDX_Text(pDX, IDC_EDIT2, m_fileFilter);
	DDX_Text(pDX, IDC_EDIT3, m_dstFolderPath);
	DDX_Text(pDX, IDC_EDIT4, m_IDFrom);
	DDX_Text(pDX, IDC_EDIT5, m_IDTo);
}

BEGIN_MESSAGE_MAP(CForCHDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDOK, &CForCHDlg::OnBnClickedOk)
END_MESSAGE_MAP()


// CForCHDlg 消息处理程序

BOOL CForCHDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CForCHDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CForCHDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CForCHDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


//根据2个瞳孔中心和2个嘴角中心来获取需要旋转的角度。
float getAngle(vector<CvPoint> vt_pt)
{
	CvPoint pt1, pt2;

	pt1.x = int((vt_pt[0].x + vt_pt[1].x) / 2.0);
	pt1.y = int((vt_pt[0].y + vt_pt[1].y) / 2.0);
	pt2.x = int((vt_pt[3].x + vt_pt[4].x) / 2.0);
	pt2.y = int((vt_pt[3].y + vt_pt[4].y) / 2.0);

	float dist_x = pt2.x - pt1.x;
	float dist_y = pt2.y - pt1.y;
	float angle = atan(dist_x / dist_y);//2眼之间相差的角度
	float angle_degree = float((angle / CV_PI) * 180.0);
	return angle_degree;
}

//获取旋转后的图片和旋转后的特征点
int getRotatedImg(Mat img, float fAngle, vector<CvPoint> vt_inPT, Mat& outImg, vector<CvPoint>& vt_outPT)
{

	//outImg = Mat(img.rows, img.cols, img.type()); outImg.setTo(255);
	outImg = Mat::zeros(img.rows, img.cols, img.type());
	Mat rot_mat = Mat(2, 3, CV_64FC1);

	Point center = Point(img.cols / 2, img.rows / 2);
	float fScale = 1.0;
	rot_mat = getRotationMatrix2D(center, fAngle, fScale);
	warpAffine(img, outImg, rot_mat, outImg.size());

	for (int i = 0; i < vt_inPT.size(); i++)
	{
		int x = vt_inPT[i].x;
		int y = vt_inPT[i].y;
		float A11 = rot_mat.at<double>(0, 0);
		float A12 = rot_mat.at<double>(0, 1);
		float b1 = rot_mat.at<double>(0, 2);
		float A21 = rot_mat.at<double>(1, 0);
		float A22 = rot_mat.at<double>(1, 1);
		float b2 = rot_mat.at<double>(1, 2);
		CvPoint pt;
		pt.x = int(A11 * x + A12 * y + b1 + 0.5);
		pt.y = int(A21 * x + A22 * y + b2 + 0.5);
		vt_outPT.push_back(pt);
	}
	return 0;
}

//获取尺度归一化后的图片。瞳孔中心和嘴角中心y轴占25%像素，x轴放在中心，瞳孔之上占y轴占37%像素，嘴角之下y轴占38%像素。
int getScaledImg(Mat img, vector<CvPoint> vt_inPT, Mat& outImg, Size stdSZ, vector<CvPoint>& vt_outPT)
{
	CvPoint pt1;
	CvPoint pt2;
	pt1.x = int(float(vt_inPT[0].x + vt_inPT[1].x) / 2.0 + 0.5);
	pt1.y = int(float(vt_inPT[0].y + vt_inPT[1].y) / 2.0 + 0.5);
	pt2.x = int(float(vt_inPT[3].x + vt_inPT[4].x) / 2.0 + 0.5);
	pt2.y = int(float(vt_inPT[3].y + vt_inPT[4].y) / 2.0 + 0.5);

	int Ydist = (pt2.y - pt1.y);
	float R = float(Ydist) / (float(stdSZ.height) * 0.259); //嘴角中心和瞳孔中心距离26个像素
	Size sz;
	sz.width = int((float(img.cols) / R) + 0.5);
	sz.height = int((float(img.rows) / R) + 0.5);
	cv::resize(img, img, sz);

	//Mat fmat;
	//Size fsz;
	//fsz.width = sz.height;
	//fsz.height = sz.width;
	//transpose(img, fmat);
	//flip(fmat, fmat, 1);
	//cv::resize(fmat, fmat, fsz);
	//transpose(fmat, fmat);
	//flip(fmat, fmat, 0);
	//img = fmat.clone();


	Mat bigMat = Mat(img.rows + stdSZ.height, img.cols + stdSZ.width, img.type()); bigMat.setTo(0);
	Mat subMat = Mat(bigMat, Rect(stdSZ.width / 2, stdSZ.height / 2, img.cols, img.rows));
	img.copyTo(subMat);

	float topCount = float(stdSZ.height) * 0.5;
	float bottomCount = float(stdSZ.height) - float(stdSZ.height) * 0.259 - topCount;

	Rect rt;
	rt.x = (float(pt1.x) / R) - (stdSZ.width / 2.0) + stdSZ.width / 2;
	rt.y = (float(pt1.y) / R) - topCount + stdSZ.height / 2;
	rt.width = stdSZ.width;
	rt.height = stdSZ.height;

	outImg = Mat(bigMat, rt).clone();

	for (int i = 0; i < vt_inPT.size(); i++)
	{
		CvPoint pt;
		pt.x = int((float(vt_inPT[i].x) / R) + 0.5) + stdSZ.width / 2 - rt.x;
		pt.y = int((float(vt_inPT[i].y) / R) + 0.5) + stdSZ.height / 2 - rt.y;
		vt_outPT.push_back(pt);
	}

	return 0;
}

/*----------------------------------------------------------------------------
img：		输入原始灰度图片
vt_inPT：	输入的5个特征点
outImg：	输出归一化好了的图片
stdSZ：		归一化图片的尺寸（100,100）
vt_outPT：	归一化后的图片的5个特征点
----------------------------------------------------------------------------*/
int getStdImg(Mat img, vector<CvPoint> vt_inPT, Mat& outImg, Size stdSZ, vector<CvPoint>& vt_outPT)
{
	float angleDegree = getAngle(vt_inPT);
	Mat rotatedImg;
	vector<CvPoint> vt_rotatedImgPt;
	getRotatedImg(img, -angleDegree, vt_inPT, rotatedImg, vt_rotatedImgPt);
	getScaledImg(rotatedImg, vt_rotatedImgPt, outImg, stdSZ, vt_outPT);

	return 0;
}

void CForCHDlg::OnBnClickedOk()
{

	//根据文件夹名字拼接List.txt文件。
	UpdateData(TRUE);
	C_Folder OF;
	C_Text OT;
	vector<string> vt_str;

	string str_srcFolder = m_folderPath.GetBuffer();
	string str_fileFilter = m_fileFilter.GetBuffer();
	string str_dstFolder = m_dstFolderPath.GetBuffer();
	vector<FilesInFolder> vt_FIF;
	OF.getFileFromFolder_faster(&str_srcFolder, &str_fileFilter, true, vt_FIF);
	OF.creatFolder(str_srcFolder, str_dstFolder, true);

	for (int i = 0; i < vt_FIF.size(); i++)
	{
		//获取图片和特征点

		Mat img = imread(vt_FIF[i].strFilePath);
		Mat channel[3];
		split(img, channel);

		string str_ptsPath = vt_FIF[i].strFilePath;
		str_ptsPath = str_ptsPath.substr(0, str_ptsPath.length() - 3) + "pts";
		bool isExist = OF.isFileExist(str_ptsPath);
		if (isExist == false)
			continue;

		vector<CvPoint> vt_pt, vt_opt, vt_ipt,vt_tmp;
		OT.ReadPTSFile(vt_pt, str_ptsPath);

		Mat stdImg;
		Mat stdImg_B;
		Mat stdImg_G;
		Mat stdImg_R;

		if ((vt_pt.size() != 5) && (vt_pt.size() != 21))
			continue;

		if (vt_pt.size() == 5)
		{
			for (int j = 0; j < vt_pt.size(); j++)
				vt_ipt.push_back(vt_pt[j]);
		}
		if (vt_pt.size() == 21)
		{
			vt_ipt.push_back(vt_pt[7]);
			vt_ipt.push_back(vt_pt[10]);
			vt_ipt.push_back(vt_pt[14]);
			vt_ipt.push_back(vt_pt[17]);
			vt_ipt.push_back(vt_pt[19]);
		}

		//for (int j = 0; j < vt_pt.size(); j++)
		//	vt_ipt.push_back(vt_pt[j]);

		//获取归一化图片
		getStdImg(channel[0], vt_ipt, stdImg_B, Size(256, 256), vt_tmp);
		getStdImg(channel[1], vt_ipt, stdImg_G, Size(256, 256), vt_tmp);
		getStdImg(channel[2], vt_ipt, stdImg_R, Size(256, 256), vt_opt);
		//Mat split_img[3] = { stdImg_R, stdImg_G, stdImg_B };
		Mat split_img[3] = { stdImg_B, stdImg_G, stdImg_R };
		merge(split_img, 3, stdImg);

		//获取保存路径
		string folderPath = vt_FIF[i].strFilePath;
		folderPath = folderPath.substr(str_srcFolder.length(), folderPath.length() - str_srcFolder.length());
		folderPath = str_dstFolder + folderPath;
		folderPath = folderPath.substr(0, folderPath.length() - 3) + "jpg";
		//folderPath = folderPath.substr(0, folderPath.length() - 3) + "bmp";
		string ptsFilePath = folderPath.substr(0, folderPath.length() - 3) + "pts";
		//Mat finaImg = stdImg(cv::Rect(16, 16, 64, 64)).clone();

		//Mat finaImg = stdImg(cv::Rect(22.5, 20, 55, 60)).clone();

		//Mat finaImg = stdImg(cv::Rect(13,10,24,30)).clone();

		//仅仅保存有特征点的图片到另一文件夹
		//imwrite(folderPath, finaImg);
		imwrite(folderPath, stdImg);
		OT.SavePTSFile(vt_opt, ptsFilePath);
	}

	return;


}
