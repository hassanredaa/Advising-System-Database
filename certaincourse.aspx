<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="certaincourse.aspx.cs" Inherits="Advising_System.certaincourse" %>

<!DOCTYPE html>
<style>

    body {
  background-color: #f5f5f5;
  font-family: 'Arial', sans-serif;
  margin: 0;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
  text-align: center;
  font-size: 20px;
}

.container {
  text-align: center;
}

h1 {
  color: #ff5733; /* Vibrant orange */
  font-size: 3em;
  letter-spacing: 3px;
  margin-bottom: 20px;
  animation: bounce 1s infinite alternate;
}

p {
  color: #3498db; /* Bright blue */
  font-size: 1.2em;
}

.input-container {
  margin-bottom: 20px;
}

input[type="text"] {
  padding: 10px;
  font-size: 1em;
  border: 2px solid #3498db; /* Bright blue border */
  border-radius: 5px;
  width: 200px;
  transition: border-color 0.3s ease;
}

input[type="text"]:focus {
  border-color: #2980b9; /* Darker blue on focus */
  outline: none;
}

.button {
  display: inline-block;
  padding: 10px 20px;
  background-color: #e74c3c; /* Energetic red */
  color: #fff;
  text-decoration: none;
  font-size: 1em;
  border-radius: 5px;
  transition: background-color 0.3s ease;
}

.button:hover {
  background-color: #c0392b; /* Darker red on hover */
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-20px);
  }
  60% {
    transform: translateY(-10px);
  }
}

</style>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Course ID<br />
            <asp:TextBox ID="cid" runat="server"></asp:TextBox>
            <br />
            <br />
            Instructor ID<br />
            <asp:TextBox ID="iid" runat="server"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="Button1" runat="server" Text="Enter" CssClass="button" OnClick="Button1_Click"/>
            <br />
            <br />
            <asp:Literal ID="Literal1" runat="server"></asp:Literal>
            <br />
            <br />
            <asp:Button ID="Button2" runat="server" CssClass="button" OnClick="Button2_Click" Text="Back to HomePage" />
        </div>
    </form>
</body>
</html>
