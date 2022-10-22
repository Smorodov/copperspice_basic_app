/***********************************************************************
*
* Copyright (c) 2012-2022 Barbara Geller
* Copyright (c) 2012-2022 Ansel Sermersheim
* Copyright (c) 2015 The Qt Company Ltd.
*
* This file is part of KitchenSink.
*
* KitchenSink is free software, released under the BSD 2-Clause license.
* For license details refer to LICENSE provided with this project.
*
* CopperSpice is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*
* https://opensource.org/licenses/BSD-2-Clause
*
***********************************************************************/

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <ui_mainwindow.h>

#include <QMainWindow>

class MainWindow : public QMainWindow
{
   CS_OBJECT(MainWindow)

 public:
   explicit MainWindow();
   ~MainWindow();
   void addMdiChild(QWidget *);

 private:
   // slot methods can be declared as standard methods when using method pointers in connect()

   void actionClose_Window();
   void actionCloseAll_Windows();
   void actionExit_Program();

   //

   Ui::MainWindow *m_ui;
   void changeEvent(QEvent *event);
};

#endif
