from tkinter import *
import pymysql as p
from tkinter import messagebox
from tkinter.ttk import Combobox
from tkinter.ttk import Treeview
import time
import datetime
import serial

bar,btn,b1,b2,b3,b4,cur,con,e1,e2,e3,e4,e5,i,ps=None,None,None,None,None,None,None,None,None,None,None,None,None,None,None
window,win=None,None
line,lineBook=None,None 
lineNow,lineNowBook=None,None
Tr = False
com1d,com1m,com1y,com2d,com2m,com2y=None,None,None,None,None,None

month=['Janvier','Fevrier','Mars','Avril','Mai','Juin','Juillet','Aôut','Septembre','Octobre','Novembre','Décembre']
y = list(range(2020, 2070))
d = list(range(1,32))

def seConnecterlibrairie():
    global window,line,lineNow
    connecterBD()
    connecterPSempreinte()
    lineNow = line
    for i in range(cur.rowcount):
        data=cur.fetchone()
        if line==str(data[1]):
            quitterBD()
            librairie()
            break
    else:
        window.withdraw()
        quitterBD()
        Accueil()

def librairie():
    global window
    window.withdraw()
    global win,b1,b2,b3,b4
    win=Tk()
    win.title('librairie')
    win.geometry("400x400+480+180")
    win.resizable(False,False)
    b2=Button(win, height=2,width=30,text=' Emprunter un livre ',command=emprunterLivre)
    b3=Button(win, height=2,width=30,text=' Retourner un livre ',command=retournerLivre)
    b4=Button(win, height=2,width=30,text=' Liste des livres ',command=listerLivres)
    b5=Button(win, height=2,width=30,text=' Livres empruntés ',command=livresEmpr)
    b7=Button(win, height=2,width=30,text=' Se déconnecter ',command=seDeconnecter)
    b2.place(x=100,y=80)
    b3.place(x=100,y=130)
    b4.place(x=100,y=180)
    b5.place(x=100,y=230)
    b7.place(x=100,y=330)
    win.mainloop()

def ajouterLivre():
    global win
    win.destroy()
    win=Tk()
    win.title('Ajouter Livre')
    win.geometry("400x400+480+180")
    win.resizable(False,False)
    suj=Label(win,text='Sujet')
    tit=Label(win,text='Titre')
    auth=Label(win,text='Auteur')
    global e1,b,b1
    e1=Entry(win,width=25)
    global e2
    e2=Entry(win,width=25)
    global e3
    e3=Entry(win,width=25)
    btn=Button(win, height=2,width=21,text=' Scanner livre ',command=connecterPSlivre)
    b=Button(win, height=2,width=21,text=' Ajouter livre au BD ',command=ajouterLivres)
    b1=Button(win, height=2,width=21,text=' Quitter ',command=quitterLivres)
    suj.place(x=70,y=50)
    tit.place(x=70,y=90)
    auth.place(x=70,y=130)
    e1.place(x=180,y=50)
    e2.place(x=180,y=90)
    e3.place(x=180,y=130)
    btn.place(x=180,y=160)
    b.place(x=180,y=210)
    b1.place(x=180,y=260)
    win.mainloop()

def ajouterLivres():
    connecterBD()
    q='INSERT INTO livres VALUE("%s","%s","%s","%s")'
    global cur,con
    cur.execute(q%(e1.get(),e2.get(),e3.get(),lineBook))
    con.commit()
    win.destroy()
    messagebox.showinfo("livres", "Livre ajouté !!")
    quitterBD()
    admin()

def quitterLivres():
    global win
    win.destroy()
    if lineNow == "admin":
        admin()
    else:
        librairie()   
    

def emprunterLivre():
    global win,line,lineBook
    win.destroy()
    win=Tk()
    win.title('Livres empruntés')
    win.geometry("400x440+480+180")
    win.resizable(False,False)
    TitreA=Label(win,text='Emprunter ',font='Helvetica 30 bold')
    TitreB=Label(win,text=' livre',font='Helvetica 30 bold')
    issue=Label(win,text='Date d\'emprunt')
    exp=Label(win,text='Date de retour')
    global e1,b,b1
    
    global com1y,com1m,com1d,com2y,com2m,com2d
    com1y=Combobox(win,value=y,width=5)
    com1m=Combobox(win,value=month,width=5)
    com1d=Combobox(win,value=d,width=5)
    com2y=Combobox(win,value=y,width=5)
    com2m=Combobox(win,value=month,width=5)
    com2d=Combobox(win,value=d,width=5)
    now=datetime.datetime.now()
    com1y.set(now.year)
    com1m.set(month[now.month-1])
    com1d.set(now.day)
    
    com2y.set(now.year)
    com2m.set(month[now.month-1])
    com2d.set(now.day)

    
    line=""
    lineBook=""
    bttn=Button(win, height=2,width=21,text=' Scanner empreinte ',command=connecterPSempreinte)
    theBtn=Button(win, height=2,width=21,text=' Scanner livre ',command=connecterPSlivre)
    b=Button(win, height=2,width=21,text=' Emprunter livre ',command=emprunterLivres)
    b1=Button(win, height=2,width=21,text=' Quitter ',command=quitterLivres)
    TitreA.place(x=40,y=30)
    TitreB.place(x=250,y=30)
    issue.place(x=70,y=155)
    exp.place(x=70,y=185)
    com1y.place(x=180,y=155)
    com1m.place(x=230,y=155)
    com1d.place(x=280,y=155)
    com2y.place(x=180,y=185)
    com2m.place(x=230,y=185)
    com2d.place(x=280,y=185)
    bttn.place(x=178,y=238)
    theBtn.place(x=178,y=285)
    b.place(x=178,y=332)
    b1.place(x=178,y=379)


    win.mainloop()

def emprunterLivres():
    global win,line,lineBook
    userNom=""
    connecterBD()
    cur.execute('SELECT * FROM livresEmpruntes')
    for i in range(cur.rowcount):
        data=cur.fetchone()
        if lineBook==str(data[4]) : 
            messagebox.showinfo("Impossible d'emprunter le livre", "livre déja emprunté !!")
            quitterBD()
            win.destroy()
            librairie()
            break


    cur.execute('SELECT * FROM login')
    for i in range(cur.rowcount):
        data=cur.fetchone()
        if line==str(data[1]) :
            userNom=str(data[0]) 


    cpt = False
    cur.execute('SELECT * FROM livres')
    for i in range(cur.rowcount):
        data=cur.fetchone()
        if lineBook==str(data[3]) and line == lineNow :
            q='INSERT INTO livresEmpruntes VALUE("%s","%s","%s","%s","%s")'
            i=datetime.datetime(int(com1y.get()),month.index(com1m.get())+1,int(com1d.get()))
            e=datetime.datetime(int(com2y.get()),month.index(com2m.get())+1,int(com2d.get()))
            i=i.isoformat()
            e=e.isoformat()
            cur.execute(q%(userNom,str(data[1]),i,e,lineBook))
            cpt = True
            con.commit()
            win.destroy()
            messagebox.showinfo("livres", "livre emprunté")
            quitterBD()
            librairie()
            break
    if cpt == False :        
        messagebox.showinfo("Erreur", "Livre ou Empreinte digitale maldonné(e) !!")

def retournerLivre():
    global win,line,lineBook
    win.destroy()
    win=Tk()
    win.title('Retourner livre')
    win.geometry("400x400+480+180")
    win.resizable(False,False)
    ret=Label(win,text='Retourner ',font='Helvetica 30 bold')
    livre=Label(win,text=' livre',font='Helvetica 30 bold')
    date=Label(win,text='dateDeRetour')
    exp=Label(win,text='')
    global b,b1
    global com1y,com1m,com1d,com2y,com2m,com2d
    com1y=Combobox(win,value=y,width=5)
    com1m=Combobox(win,value=month,width=5)
    com1d=Combobox(win,value=d,width=5)
    '''com2y=Combobox(win,width=5)
    com2m=Combobox(win,width=5)
    com2d=Combobox(win,width=5)'''
    now=datetime.datetime.now()
    com1y.set(now.year)
    com1m.set(month[now.month-1])
    com1d.set(now.day)

    line=""
    lineBook=""
    bttn=Button(win, height=2,width=21,text=' Scanner empreinte ',command=connecterPSempreinte)
    theBtn=Button(win, height=2,width=21,text=' Scanner livre ',command=connecterPSlivre)
    b=Button(win, height=2,width=21,text=' Retourner livre ',command=retournerLivres)
    b1=Button(win, height=2,width=21,text=' Quitter ',command=quitterLivres)
    ret.place(x=45,y=30)
    livre.place(x=250,y=30)
    date.place(x=70,y=145)
    exp.place(x=70,y=200)
    com1y.place(x=180,y=145)
    com1m.place(x=230,y=145)
    com1d.place(x=280,y=145)
    '''com2y.place(x=180,y=200)
    com2m.place(x=230,y=200)
    com2d.place(x=280,y=200)'''
    bttn.place(x=178,y=185)
    theBtn.place(x=178,y=227)
    b.place(x=178,y=269)
    b1.place(x=178,y=309)
    win.mainloop()


def retournerLivres():
    global lineBook
    connecterBD()
    cur.execute('SELECT * FROM livres')
    for i in range(cur.rowcount):
        data=cur.fetchone()
        if lineBook==str(data[3]) :
            lineBook=str(data[1])  

    cur.execute('SELECT * FROM livresEmpruntes')
    cpt = False
    for i in range(cur.rowcount):
        data=cur.fetchone()
        if lineBook==str(data[1]) and line == lineNow:
            q='SELECT dateDeRetour FROM livresEmpruntes WHERE Titre="%s"'
            cur.execute(q%(lineBook))
            e=cur.fetchone()
            e=str(e[0])
            i=datetime.date.today()
            e=datetime.date(int(e[:4]),int(e[5:7]),int(e[8:10]))
            if i<=e:
                a='DELETE FROM livresEmpruntes WHERE Titre="%s"'
                cur.execute(a%lineBook)
                cpt = True
                con.commit()
                messagebox.showinfo("Merci",'Retour fait avec success')
            else:
                t=str((i-e)*10)
                messagebox.showinfo("Attention",'Vous etes en retard !!')
                a='DELETE FROM livresEmpruntes WHERE Titre="%s"'
                cur.execute(a%lineBook)
                cpt = True
                con.commit()
            win.destroy()
            quitterBD()
            librairie()
            break        
    if cpt == False :
        messagebox.showinfo("Error",'Livre ou Empreinte digitale maldonné(e) !!')   

def listerLivres():
    win=Tk()
    win.title('Liste des livres')
    win.geometry("800x300+270+180")
    win.resizable(False,False)

    treeview=Treeview(win,columns=("Sujet","Titre","Auteur","No de série"),show='headings')
    treeview.heading("Sujet", text="Sujet")
    treeview.heading("Titre", text="Titre")
    treeview.heading("Auteur", text="Auteur")
    treeview.heading("No de série", text="No de série")
    treeview.column("Sujet", anchor='center')
    treeview.column("Titre", anchor='center')
    treeview.column("Auteur", anchor='center')
    treeview.column("No de série", anchor='center')
    index=0
    iid=0
    connecterBD()
    q='SELECT * FROM livres'
    cur.execute(q)
    details=cur.fetchall()
    for row in details:
        treeview.insert("",index,iid,value=row)
        index=iid=index+1
    treeview.pack()
    win.mainloop()
    quitterBD()

def livresEmpr():
    connecterBD()
    q='SELECT * FROM livresEmpruntes'
    cur.execute(q)
    details=cur.fetchall()
    if len(details)!=0:
        win=Tk()
        win.title('Liste des livres')
        win.geometry("800x300+270+180")
        win.resizable(False,False)    
        treeview=Treeview(win,columns=("NomEtudiant","Titre","dateDePrete","dateDeRetour"),show='headings')
        treeview.heading("NomEtudiant", text="Etudiant")
        treeview.heading("Titre", text="Titre")
        treeview.heading("dateDePrete", text="Date d\'emprunt")
        treeview.heading("dateDeRetour", text="Date de retour")
        treeview.column("NomEtudiant", anchor='center')
        treeview.column("Titre", anchor='center')
        treeview.column("dateDePrete", anchor='center')
        treeview.column("dateDeRetour", anchor='center')
        index=0
        iid=0
        for row in details:
            treeview.insert("",index,iid,value=row)
            index=iid=index+1
        treeview.pack()
        win.mainloop()
    else:
        messagebox.showinfo("Livres","Pas de livre empreinté !!")
    quitterBD()

def supprimerLivre():
    global win,line
    line = ""
    win.destroy()
    win=Tk()
    win.title('Supprimer livre')
    win.geometry("400x400+480+180")
    win.resizable(False,False)
    usid=Label(win,text=' Titre ')
    global e1
    e1=Entry(win)
    global e2,b2
    btn=Button(win, height=2,width=17,text=' Scanner empreinte ',command=connecterPSempreinte)
    b1=Button(win, height=2,width=17,text=' Supprimer ',command=supprimerLivres)
    b2=Button(win, height=2,width=17,text=' Quitter ',command=quitterLivres)
    usid.place(x=80,y=100)
    e1.place(x=180,y=100)
    btn.place(x=150,y=180)
    b1.place(x=150,y=230)
    b2.place(x=150,y=280)
    win.mainloop()

def supprimerLivres():
    connecterBD()
    if line=='admin':
        q='DELETE FROM livres WHERE titre="%s"'
        cur.execute(q%((e1.get())))
        con.commit()
        win.destroy()
        messagebox.showinfo("Supprimer", "Livre supprimé")
        quitterBD()
        admin()
    elif line == "":
        messagebox.showinfo("Erreur", "Pas de données biométrique \n ou données sont pas confendus !!")
        quitterBD()   
    else:
        messagebox.showinfo("Erreur", "Livre ou Empreinte digitale maldonné(e) !!")
        quitterBD()

def seConnecterAdmin():
    global line,lineNow
    connecterPSempreinte()
    lineNow = line
    if line =='admin':
        admin()

def admin():
    window.withdraw()
    global win,b1,b2,b3,b4,cur,con
    win=Tk()
    win.title('Admin')
    win.geometry("400x500+480+180")
    win.resizable(False,False)
    b1=Button(win, height=2,width=25,text=' Ajouter utilisateur ',command=ajouterUtilisateur)
    b2=Button(win, height=2,width=25,text=' Lister les utilisateurs ',command=listerUtilisateurs)
    b3=Button(win, height=2,width=25,text=' Supprimer utilisateur ',command=supprimerUtilisateur)
    b5=Button(win, height=2,width=25,text=' Ajouter un livre ',command=ajouterLivre)
    b6=Button(win, height=2,width=25,text=' Liste des livres ',command=listerLivres)
    b7=Button(win, height=2,width=25,text=' Supprimer livre ',command=supprimerLivre)
    b8=Button(win, height=2,width=25,text=' Livres empreintés ',command=livresEmpr)
    b4=Button(win, height=2,width=25,text=' Se déconnecter ',command=seDeconnecter)
    b1.place(x=110,y=30)
    b2.place(x=110,y=80)
    b3.place(x=110,y=130)
    b5.place(x=110,y=180)
    b6.place(x=110,y=230)
    b7.place(x=110,y=280)
    b8.place(x=110,y=330)
    b4.place(x=110,y=400)
    win.mainloop()

def seDeconnecter(): 
    global line,lineNow
    line = "Not Found" 
    lineNow = None
    win.destroy()
    try:
        quitterBD()
    except:
        print("Au revoir")
    Accueil()

def quitterBD():
    global con,cur
    cur.close()
    con.close()

def ajouterUtilisateur():
    global win,line
    win.destroy()
    win=Tk()
    win.title('Ajouter utilisateur')
    win.geometry("400x400+480+180")
    win.resizable(False,False)
    Nom=Label(win,text='Nom')
    Filiere=Label(win,text='Filiere')
    mob=Label(win,text='CIN')
    line=''
    global e1,b
    e1=Entry(win,width=25)
    global e2
    e2=Entry(win,width=25)
    global e3
    e3=Entry(win,width=25)
    btn=Button(win, height=2,width=21,text=' Scanner empr d\'utilisateur ',command=connecterPSempreinte)
    b=Button(win, height=2,width=21,text=' Ajouter utilisateur ',command=ajouterUtilisateurs)
    b1=Button(win, height=2,width=21,text=' Quitter ',command=quitterUtilisateurs)
    Nom.place(x=70,y=100)
    Filiere.place(x=70,y=140)
    mob.place(x=70,y=180)
    e1.place(x=180,y=100)
    e2.place(x=180,y=140)
    e3.place(x=180,y=180)

    btn.place(x=178,y=220)
    b.place(x=178,y=270)
    b1.place(x=178,y=320)
    win.mainloop()


def ajouterUtilisateurs():
    global line,lineNow,e1,e2,e3
    bool = True
    connecterBD()
    q='INSERT INTO Login VALUE("%s","%i","%s","%s")'
    global con,cur
    cur.execute('SELECT * FROM login')
    for i in range(cur.rowcount):
        data=cur.fetchone()
        if line==str(data[1]) :
            messagebox.showinfo("Utilisateur", "ID d\'empreinte d\'utilisateur existe déja !!")
            bool = False
            quitterBD()
            break
            
    if (bool) :
        cur.execute(q%(e1.get(),int(line),e2.get(),e3.get()))
        con.commit()
        win.destroy()
        messagebox.showinfo("Utilisateur", "Utilisateur ajouté !!")
        quitterBD()
        admin()


def quitterUtilisateurs():
    global win
    win.destroy()
    admin()

def listerUtilisateurs():
    win=Tk()
    win.title('Lister Utilisateurs')
    win.geometry("800x300+270+180")
    win.resizable(False,False)
    treeview=Treeview(win,columns=("nom","idUtilisateur","Filiere","CIN"),show='headings')
    treeview.heading("nom", text="nom")
    treeview.heading("idUtilisateur", text="idUtilisateur")
    treeview.heading("Filiere", text="Filiere")
    treeview.heading("CIN", text="CIN")
    treeview.column("nom", anchor='center')
    treeview.column("idUtilisateur", anchor='center')
    treeview.column("Filiere", anchor='center')
    treeview.column("CIN", anchor='center')
    index=0
    iid=0
    connecterBD()
    details=cur.fetchall()
    for row in details:
        treeview.insert("",index,iid,value=row)
        index=iid=index+1
    treeview.pack()
    win.mainloop()
    quitterBD()


def supprimerUtilisateur():
    global win,line
    line =""
    win.destroy()
    win=Tk()
    win.title('Supprimer utilisateur')
    win.geometry("400x400+480+180")
    win.resizable(False,False)
    usid=Label(win,text='CIN')
    global e1
    e1=Entry(win)
    global e2,b2
    btn=Button(win, height=2,width=17,text=' Empreinte d\'admin ',command=connecterPSempreinte)
    b1=Button(win, height=2,width=17,text=' Supprimer ',command=supprimerUtilisateurs)
    b2=Button(win, height=2,width=17,text=' Quitter ',command=quitterUtilisateurs)
    usid.place(x=80,y=100)
    e1.place(x=180,y=100)
    btn.place(x=150,y=180)
    b1.place(x=150,y=230)
    b2.place(x=150,y=280)
    win.mainloop()

def supprimerUtilisateurs():
    connecterBD()
    if line =='admin':
        q='DELETE FROM Login WHERE CIN="%s"'
        cur.execute(q%(e1.get()))
        con.commit()
        win.destroy()
        messagebox.showinfo("Supprimer", "Utilisateur supprimé !!")
        quitterBD()
        admin()
    elif line == "":
        messagebox.showinfo("Erreur", "Pas de données biométrique \n ou données sont pas confendus !!")
        quitterBD()    
    else:
        messagebox.showinfo("Erreur", "Livre ou Empreinte digitale maldonné(e) !!")
        quitterBD()

def connecterBD():
    global con,cur
    #entrer your userNom and password of MySQL
    con=p.connect(host="localhost",user="root",passwd="")
    cur=con.cursor()
    cur.execute('CREATE DATABASE IF NOT EXISTS librairie')
    cur.execute('USE librairie')
    global entrer
    if entrer==1:
        l='CREATE TABLE IF NOT EXISTS Login(nom varchar(20),idUtilisateur varchar(10),Filiere varchar(20),CIN varchar(20))'
        b='CREATE TABLE IF NOT EXISTS livres(Sujet varchar(20),titre varchar(20),auteur varchar(20),serie varchar(20))'
        i='CREATE TABLE IF NOT EXISTS livresEmpruntes(NomEtudiant varchar(20),Titre varchar(20),dateDePrete date,dateDeRetour date,IDlivre varchar(20))'
        j='CREATE TABLE IF NOT EXISTS livresDisponibles(NomEtudiant varchar(20),Titre varchar(20),dateDePrete date,dateDeRetour date)'
        cur.execute(l)
        cur.execute(b)
        cur.execute(i)
        cur.execute(j)
        entrer=entrer+1
    query='SELECT * FROM Login'
    cur.execute(query)


def connecterPSempreinte():
    global line,bar 
    # Définir le port série 
    port = 'COM11'

    # Définir le débit en bauds
    baudrate = 9600

    try:
        # Ouvrir le port série
        ser = serial.Serial(port, baudrate)
        print("Port série ouvert avec succès sur", port)
        # Un booléan qui indique si on a pas encore 
        # lit une donnée du port serial
        Tr = True
        # Continuer a lire en continu les données du port série
        # jusqu'a avoir une donnée valable
        while Tr:
            # Lire une ligne de données depuis le port série
            line = ser.readline().decode('utf-8').strip()
            if line != "Not found" :
                Tr = False

    except serial.SerialException as e:
        print("Erreur lors de l'ouverture du port série:", e)

    finally:
        # Fermer le port série à la fin
        if ser.is_open:
            ser.close()
            print("Port série fermé.")



def connecterPSlivre():
    global lineBook,bar 
    # Définir le port série 
    port = 'COM11'

    # Définir le débit en bauds
    baudrate = 9600

    try:
        # Ouvrir le port série
        ser = serial.Serial(port, baudrate)
        print("Port série ouvert avec succès sur", port)
        Tr = True
        # Lire en continu les données du port série
        while Tr:
            # Lire une ligne de données depuis le port série
            lineBook = ser.readline().decode('utf-8').strip()
            if lineBook != "Not found" and lineBook != "Error when receiving data" and lineBook != "Error when reading fingerprint" and lineBook != "No fingerprint in database":
                Tr = False
            # Afficher la ligne de données

    except serial.SerialException as e:
        print("Erreur lors de l'ouverture du port série:", e)

    finally:
        # Fermer le port série à la fin
        if ser.is_open:
            ser.close()
            print("Port série fermé.")            



def Accueil():
    try:
        global window,b1,b2,bar,btn,e1,con,cur,win
        window=Tk()
        window.title('Bienvenue')
        window.resizable(False,False)
        window.geometry("420x400+480+180")
        TilteUp=Label(window,text='AUTHENTIFICATION ',font='Helvetica 25 bold')
        TilteDown=Label(window,text='   BIOMÉTRIQUE ',font='Helvetica 25 bold')
        TilteUp.place(x=50,y=40)
        TilteDown.place(x=60,y=100)
        b1=Button(window,text=' Empreinte d\'utilisateur ' ,height=2,width=25,command=seConnecterlibrairie)
        b2=Button(window,text=' Empreinte d\'administrateur ', height=2,width=25,command=seConnecterAdmin)
        btn=Button(window,text=' Quitter ', height=2,width=25,command=window.destroy)
        b1.place(x=115,y=200)
        b2.place(x=115,y=250)
        btn.place(x=115,y=320)
        window.mainloop()
    except Exception:
        window.destroy()



entrer=1
Accueil()