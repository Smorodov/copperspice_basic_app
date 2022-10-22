
#include <mainwindow.h>
#include <QMdiSubWindow>

MainWindow::MainWindow()
	: QMainWindow(), m_ui(new Ui::MainWindow)
{
	m_ui->setupUi(this);

	setWindowTitle(tr("KitchenSink"));
	setWindowIcon(QIcon("://resources/ks.ico"));

	connect(m_ui->actionClose_Window, &QAction::triggered, this, &MainWindow::actionClose_Window);
	connect(m_ui->actionCloseAll_Windows, &QAction::triggered, this, &MainWindow::actionCloseAll_Windows);
	connect(m_ui->actionExit_Program, &QAction::triggered, this, &MainWindow::actionExit_Program);

}

MainWindow::~MainWindow()
{
	delete m_ui;
}

void MainWindow::changeEvent(QEvent* event)
{
	if (event->type() == QEvent::LanguageChange) {
		m_ui->retranslateUi(this);
	}

	// calls parent, will change the title bar
	QMainWindow::changeEvent(event);
}

void MainWindow::addMdiChild(QWidget* oDw)
{
	QMdiSubWindow* subWindow = m_ui->mdiArea->addSubWindow(oDw);
	subWindow->show();
}

// file
void MainWindow::actionClose_Window()
{
	QMdiSubWindow* temp = m_ui->mdiArea->currentSubWindow();

	if (temp) {
		temp->close();
	}
}

void MainWindow::actionCloseAll_Windows()
{
	m_ui->mdiArea->closeAllSubWindows();
}

void MainWindow::actionExit_Program()
{
	close();
}

